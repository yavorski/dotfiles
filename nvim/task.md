# Task

## Setup `mini.statusline`

Current setup uses `lualine.nvim`

Current confiration is in `./lua/plugins/lualine.lua`
Also uses `./lua/colors/status-line.lua`
Source code of the `lualine.nvim` is in `~/dev/open-sos/lualine.nvim/`

## Goal is to have identical statusline configured with `mini.statusline`

Source code of the `mini.statusline` is in `~/dev/open-sos/nvim-mini/mini.statusline/`

Read my current `lualine.nvim` configuration, try do do minimal identical setup with `mini.statusline`

For the `mini.tabline` do the default setup - install plugin and call setup. do not confire anything i will setup options later.
Repostory is located here `~/dev/open-sos/nvim-mini/mini.tabline/`

The plugins should be configured in

* ./lua/nvm/mini-statusline.lua
* ./lua/nvm/mini-tabline.lua

Do not delete the `./lua/plugins/lualine.lua` for now ( i need it for reference )

Do NOT move/edit/delete any config files outside the current directory ... work only in the current folder.
This is my dotfiles folder i will setup later the user and system wide configuration files.
Do NOT edit or override any system wides config!
