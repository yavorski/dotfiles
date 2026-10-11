--- @brief
--- Sink resolution mirroring upstream msg_show (+pager_shown).
--- Re-check past upstream 7e1ae5115f. Lets wrap track the real sink.

local ui2 = require("vim._core.ui2")
local util = require("core/ui/util")

local M = {}

--- @param kind string
--- @param id integer|string?
--- @param trigger string?
--- @return "msg"|"pager"|"dialog"|nil resolved float sink; nil when upstream
--- routes to the cmd window (no float title to set)
function M.resolve(kind, id, trigger)
  trigger = trigger or ""
  local targets = ui2.cfg.msg.targets

  -- ID-pattern mapping.
  local id_target
  if type(id) == "string" then
    local k, v = next(targets)
    while k and not id_target do
      id_target = id:match(k) and v
      k, v = next(targets, k)
    end
  end

  local pager_visible = util.valid_win(ui2.wins.pager) ~= nil and not vim.api.nvim_win_get_config(ui2.wins.pager).hide

  local tgt = kind == "search_cmd" and "cmd"
    or (trigger == "typed_cmd" and pager_visible and vim.fn.getcmdwintype() == "") and "pager"
    or (trigger ~= "" and targets[trigger])
    or id_target
    or (kind ~= "" and targets[kind])
    or targets.default

  local cmd = ui2.cmd
  -- Prompt active (or would clobber cmdline) -> dialog.
  if cmd and (cmd.prompt or (cmd.level > 0 and tgt == "cmd")) and cmd.srow == 0 then
    return "dialog"
  end

  -- Below an expanded cmdline -> pager.
  if cmd and cmd.expand > 0 then
    return "pager"
  end

  -- No float title for the cmd window.
  if tgt == "cmd" then
    return nil
  end

  ---@cast tgt "msg"|"pager"|"dialog"
  return tgt
end

return M
