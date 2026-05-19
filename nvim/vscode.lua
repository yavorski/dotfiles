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
require("nvm/mini-jump")
require("nvm/mini-move")
require("nvm/mini-pairs")
require("nvm/mini-comment")
require("nvm/mini-surround")
require("nvm/mini-split-join")
require("nvm/mini-trail-space")

--- Local Lua Modules ---
require("modules/line-feed")
require("modules/buffer-only")

--- Lazy init ---
require("core/lazy").init()
