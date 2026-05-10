--- @brief Predicate: should a (kind, content) pair be dropped before routing?

local config = require("core/ui/config")
local util = require("core/ui/util")

local M = {}

--- @param kind string
--- @param content table
--- @return boolean
function M.should_skip(kind, content)
  if config.IGNORED_KINDS[kind] then
    return true
  end

  local text = util.content_to_text(content)

  for _, pat in ipairs(config.SKIP_PATTERNS) do
    if text:find(pat) then return true end
  end

  for _, sub in ipairs(config.SKIP_SUBSTRINGS) do
    if text:find(sub, 1, true) then return true end
  end

  for _, fn in ipairs(config.SKIP_FUNCS) do
    if fn(text) then return true end
  end

  return false
end

return M
