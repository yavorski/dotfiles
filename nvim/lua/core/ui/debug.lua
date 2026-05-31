--- @brief
--- Global debug helper: `d(value)` to pretty-print at DEBUG level.

local M = {}

function M.setup()
  _G.d = function(...)
    local args = { ... }
    local value = #args == 1 and args[1] or args
    vim.notify(vim.inspect(value), vim.log.levels.DEBUG)
  end
end

return M
