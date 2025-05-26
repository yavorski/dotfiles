--- @type System
local system = require("core/system")

--- @type "bold"|"double"|"none"|"rounded"|"shadow"|"single"|"solid"
local window_border = (system.is_ghostty or system.is_neovide) and "rounded" or "bold"

-- global
_G.window_border = window_border

-- set global option
vim.opt.winborder = window_border

return window_border
