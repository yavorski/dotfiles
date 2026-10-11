--- @brief
--- Wrappers around `vim._core.ui2.messages` functions

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local config = require("core/ui/config")
local util = require("core/ui/util")
local filter = require("core/ui/filter")
local titles = require("core/ui/titles")
local routing = require("core/ui/routing")
local decorate = require("core/ui/decorate")
local search_count = require("core/ui/search_count")

local M = {}
local installed = false

--- Wipe the hidden pager buffer so outputs don't stack (later chunks still append).
--- @return boolean cleared
local function wipe_hidden_pager()
  if not vim.api.nvim_buf_is_valid(ui2.bufs.pager) then
    return false
  end
  local pager = ui2.wins.pager
  local shown = pager and pager ~= -1 and vim.api.nvim_win_is_valid(pager) and not vim.api.nvim_win_get_config(pager).hide
  if shown then
    return false
  end
  vim.api.nvim_buf_set_lines(ui2.bufs.pager, 0, -1, false, {})
  return true
end

--- First content line of ui2 message chunks.
---@param content table
---@return string
local function first_line(content)
  return util.content_to_text(content):match("^[^\n]*") or ""
end

--- Drop the wipe's leftover blank line, unless the output itself starts blank.
---@param first string first content line
local function trim_leading_blank(first)
  if first == "" then
    return
  end
  if not vim.api.nvim_buf_is_valid(ui2.bufs.pager) then
    return
  end
  local topline = vim.api.nvim_buf_get_lines(ui2.bufs.pager, 0, 1, false)[1]
  local count = vim.api.nvim_buf_line_count(ui2.bufs.pager)
  if topline == "" and count > 1 then
    vim.api.nvim_buf_set_lines(ui2.bufs.pager, 0, 1, false, {})
  end
end

function M.setup()
  if installed then
    return
  end
  installed = true

  --- set_pos: re-apply decorations after upstream positioning.
  local orig_set_pos = msgs.set_pos

  msgs.set_pos = function(target, focus)
    if focus == nil then
      orig_set_pos(target)
    else
      ---@diagnostic disable-next-line: redundant-parameter -- (tgt, focus) is 0.13+;
      orig_set_pos(target, focus)
    end

    if target == nil then
      decorate.all()
    elseif target == "msg" then
      decorate.msg(ui2.wins.msg)
    elseif target == "pager" then
      decorate.float("pager", ui2.wins.pager)
    elseif target == "dialog" then
      decorate.float("dialog", ui2.wins.dialog)
    end
  end

  --- msg_show: filter + title tracking + search_count intercept.
  local orig_msg_show = msgs.msg_show
  msgs.msg_show = function(kind, content, replace_last, _, append, id, trigger)
    if filter.should_skip(kind, content) then
      return
    end

    if kind == "search_count" then
      search_count.show(util.content_to_text(content))
      return
    end

    -- Trailing newline is a terminator, not content (`:!ls` -> `":!ls\r\n"`).
    content = util.trim_trailing_newline(content)

    local title, hl = titles.resolve(kind, content)
    -- Title only the sink actually used (nil = cmd window, no title).
    local target = routing.resolve(kind, id, trigger)
    if target then
      titles.set(target, { title, hl })
    end

    -- Fresh pager per command: wipe the hidden pager buffer so outputs don't stack.
    local cleared = false
    if target == "pager" then
      cleared = wipe_hidden_pager()
    end

    local ret = orig_msg_show(kind, content, replace_last, _, append, id, trigger)

    -- Drop the leading blank line the wipe leaves behind.
    if cleared then
      trim_leading_blank(first_line(content))
    end

    -- Re-shrink: indicator placement can re-grow the float after set_pos.
    if target == "msg" then
      decorate.msg(ui2.wins.msg)
    end

    return ret
  end

  --- show_msg: auto-promote oversized msg-window content to the pager.
  local orig_show_msg = msgs.show_msg
  msgs.show_msg = function(target, kind, content, replace_last, append, id)
    if target == "msg" then
      local text = util.content_to_text(content)
      local lines = vim.split(text, "\n", { plain = true, trimempty = true })
      local width = 0

      for _, line in ipairs(lines) do
        local w = vim.api.nvim_strwidth(line)
        if w > width then
          width = w
        end
      end

      if width >= math.floor(vim.o.columns * config.PAGER_WIDTH_RATIO) or #lines >= config.PAGER_MAX_LINES then
        -- Fresh-pager wipe + title copy (no alias) for promoted output.
        local cleared = wipe_hidden_pager()
        local msg_title = titles.state.msg
        titles.state.pager = msg_title and { msg_title[1], msg_title[2] } or nil
        -- orig_show_msg positions the pager itself, no set_pos needed here.
        local ret = orig_show_msg("pager", kind, content, replace_last, append, id)
        if cleared then
          trim_leading_blank(first_line(content))
        end
        return ret
      end
    end

    return orig_show_msg(target, kind, content, replace_last, append, id)
  end

  --- msg_history_show: `:messages` / `g<` open the pager with a fixed title.
  local orig_history = msgs.msg_history_show
  if orig_history then
    msgs.msg_history_show = function(...)
      titles.state.pager = { "Messages", "Normal" }
      return orig_history(...)
    end
  end

  --- msg_clear: reset per-target title state + search virt text.
  local orig_msg_clear = msgs.msg_clear
  if orig_msg_clear then
    msgs.msg_clear = function()
      titles.reset()
      search_count.clear()
      return orig_msg_clear()
    end
  end
end

return M
