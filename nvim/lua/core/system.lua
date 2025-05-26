--- @module "core/system"
--- @class System
--- @field sysname string
--- @field is_linux boolean
--- @field is_windows boolean
--- @field is_wsl boolean
--- @field is_wsl_or_windows boolean
--- @field is_neovide boolean
--- @field is_ghostty boolean
local System = {}

--- @type string
System.sysname = vim.loop.os_uname().sysname

--- @type boolean
System.is_linux = System.sysname == "Linux"

--- @type boolean
System.is_windows = System.sysname == "Windows_NT"

--- @type boolean
System.is_wsl = vim.fn.has("wsl") == 1

--- @type boolean
System.is_wsl_or_windows = System.is_wsl or System.is_windows

--- @type boolean
System.is_neovide = vim.g.neovide == true

--- @type boolean
System.is_ghostty = vim.env.TERM_PROGRAM == "ghostty"

return System
