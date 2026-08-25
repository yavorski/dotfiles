--- @brief
--- Wrappers around `vim._core.ui2.messages` functions

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local config = require("core/ui/config")
local util = require("core/ui/util")
local filter = require("core/ui/filter")
local titles = require("core/ui/titles")
local decorate = require("core/ui/decorate")
local search_count = require("core/ui/search_count")

local M = {}
local installed = false

function M.setup()
  if installed then return end
  installed = true

  --- set_pos: re-apply decorations after upstream positioning.
  local orig_set_pos = msgs.set_pos

  msgs.set_pos = function(target, ...)
    orig_set_pos(target, ...)

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
  msgs.msg_show = function(kind, content, replace_last, history, append, id, trigger)
    if filter.should_skip(kind, content) then
      return
    end

    if kind == "search_count" then
      search_count.show(util.content_to_text(content))
      return
    end

    -- Trailing newline is a message terminator (e.g. `:!ls` -> `":!ls\r\n"`),
    -- not content; drop it so floats/pager don't gain a blank last line.
    content = util.trim_trailing_newline(content)

    local title, hl = titles.resolve(kind, content)
    -- Set the title only on the sink this kind routes to, so e.g. the pager
    -- title doesn't get overwritten by an unrelated msg-float message.
    -- Prompts are routed to the dialog, so also title the dialog for those.
    local target = config.MSG_TARGETS[kind] or "msg"
    titles.set(target, { title, hl })
    titles.set("dialog", { title, hl })

    -- Start a fresh pager view per command: when a pager-routed message arrives while the pager is hidden, wipe the (persistent) buffer so old output (previous `:!ls`, `:set?`, ...) doesn't stack.
    -- Later chunks of the same command still append, since the pager is then visible.
    local cleared = false
    if config.MSG_TARGETS[kind] == "pager" then
      local pager = ui2.wins.pager
      local shown = pager and pager ~= -1 and vim.api.nvim_win_is_valid(pager)
        and not vim.api.nvim_win_get_config(pager).hide
      if not shown and vim.api.nvim_buf_is_valid(ui2.bufs.pager) then
        vim.api.nvim_buf_set_lines(ui2.bufs.pager, 0, -1, false, {})
        cleared = true
      end
    end

    local ret = orig_msg_show(kind, content, replace_last, history, append, id, trigger)

    -- Clearing leaves an empty first line that upstream writes *after* (unless the
    -- message replaced it), producing a leading blank. Drop it if present.
    if cleared and vim.api.nvim_buf_is_valid(ui2.bufs.pager) then
      local first = vim.api.nvim_buf_get_lines(ui2.bufs.pager, 0, 1, false)[1]
      local count = vim.api.nvim_buf_line_count(ui2.bufs.pager)
      if first == "" and count > 1 then
        vim.api.nvim_buf_set_lines(ui2.bufs.pager, 0, 1, false, {})
      end
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
        if w > width then width = w end
      end

      if width >= math.floor(vim.o.columns * config.PAGER_WIDTH_RATIO) or #lines >= config.PAGER_MAX_LINES then
        -- Promoted from msg to pager: carry the title over to the pager sink.
        titles.state.pager = titles.state.msg
        -- orig_show_msg positions the pager itself, no set_pos needed here.
        return orig_show_msg("pager", kind, content, replace_last, append, id)
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
    msgs.msg_clear = function(...)
      titles.reset()
      search_count.clear()
      return orig_msg_clear(...)
    end
  end
end

return M
