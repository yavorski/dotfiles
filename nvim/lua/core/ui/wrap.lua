--- @brief Wrappers around `vim._core.ui2.messages` functions.

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

  msgs.set_pos = function(target)
    orig_set_pos(target)

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

    local title, hl = titles.resolve(kind, content)
    titles.set_all({ title, hl })

    return orig_msg_show(kind, content, replace_last, history, append, id, trigger)
  end

  --- show_msg: auto-promote oversized msg-window content to the pager.
  local orig_show_msg = msgs.show_msg
  msgs.show_msg = function(target, kind, content, replace_last, append, id)
    if target == "msg" then
      local text = util.content_to_text(content)
      local lines = vim.split(text, "\n", { plain = true })
      local width = 0

      for _, line in ipairs(lines) do
        local w = vim.api.nvim_strwidth(line)
        if w > width then width = w end
      end

      if width > math.floor(vim.o.columns * config.PAGER_WIDTH_RATIO) or #lines > config.PAGER_MAX_LINES then
        orig_show_msg("pager", kind, content, replace_last, append, id)
        msgs.set_pos("pager")
        return
      end
    end

    return orig_show_msg(target, kind, content, replace_last, append, id)
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
