--- [[ NeoVim ]] -- [[ VSCode ]] ---
--- https://github.com/vscode-neovim/vscode-neovim
--- cp ../vscode/{settings,keybindings}.json ~/.config/Code/User/
--- cp ../vscode/{settings,keybindings}.json %APPDATA%/Code/User/

--- Core Settings ---
require("core/options")
require("core/border")
require("core/keymaps")
require("core/autocmds")

--- Mini Modules ---
require("mini!/jump")
require("mini!/move")
require("mini!/pairs")
require("mini!/comment")
require("mini!/surround")
require("mini!/split-join")
require("mini!/trail-space")

--- Local Lua Modules ---
require("modules/line-feed")
require("modules/buffer-only")

--- Lazy init ---
require("core/lazy").init()
