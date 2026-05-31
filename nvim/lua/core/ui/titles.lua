--- @brief
--- Per-target title state and kind→title resolution

local config = require("core/ui/config")
local util = require("core/ui/util")

local M = {}

--- Per-target title state. Reset by `msg_clear`.
--- @type table<"msg"|"pager"|"dialog", TitleEntry?>
M.state = { msg = nil, pager = nil, dialog = nil }

--- @param kind string
--- @param content table
--- @return string title, string highlight
function M.resolve(kind, content)
  local entry = config.KIND_TITLES[kind]
  if entry then
    return entry[1], entry[2]
  end

  local text = vim.trim(util.content_to_text(content)):match("^[^\n]*") or ""
  if #text > 40 then
    text = text:sub(1, 37) .. "..."
  end

  return text ~= "" and text or "Message", "Normal"
end

--- Set the same title entry on every sink.
--- We can't know upstream's final routing, so set all three?
--- The window that actually opens will display the right one.
--- @param entry TitleEntry
function M.set_all(entry)
  M.state.msg = entry
  M.state.pager = entry
  M.state.dialog = entry
end

function M.reset()
  M.state.msg = nil
  M.state.pager = nil
  M.state.dialog = nil
end

return M
