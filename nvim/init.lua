------------------------------------------------------------
-- [[ neovim ]] [[ init.lua ]] --
------------------------------------------------------------

------------------------------------------------------------
-- Core
------------------------------------------------------------

require("core/options")
require("core/border")
require("core/neovide")
require("core/keymaps")
require("core/autocmds")

------------------------------------------------------------
-- Plugins
------------------------------------------------------------

require("plugins/color-scheme")
require("plugins/lualine")
require("plugins/fzf-lua")
require("plugins/nvim-tree")
require("plugins/noice")
require("plugins/trouble")
require("plugins/which-key")
require("plugins/scope")
require("plugins/stylus")
require("plugins/auto-tag")
require("plugins/git-signs")
-- require("plugins/marks")
-- require("plugins/diff-view")

-- tree-sitter
require("plugins/tree-sitter")

------------------------------------------------------------
-- Mini plugins
------------------------------------------------------------

require("mini!/ai")
require("mini!/map")
require("mini!/diff")
require("mini!/jump")
require("mini!/move")
require("mini!/misc")
require("mini!/icons")
require("mini!/pairs")
require("mini!/comment")
require("mini!/surround")
require("mini!/buf-remove")
require("mini!/split-join")
require("mini!/trail-space")
require("mini!/hi-patterns")
-- require("mini!/indent-scope")

------------------------------------------------------------
-- AI Modules
------------------------------------------------------------

require("ai/copilot-vim")
require("ai/code-companion")

------------------------------------------------------------
-- LSP Modules
------------------------------------------------------------

require("lsp/lazy-dev")
require("lsp/lsp-config")
-- require("lsp/dadbod")
-- require("lsp/roslyn")
-- require("lsp/rust-tools")
require("lsp/typescript-tools")
require("lsp/diagnostics")
require("lsp/blink")

------------------------------------------------------------
-- Local Lua Modules
------------------------------------------------------------

require("modules/line-feed")
require("modules/popup-menu")
require("modules/buffer-only")
require("modules/smart-close")
require("modules/smart-escape")

------------------------------------------------------------
-- lazy init
------------------------------------------------------------
require("core/lazy").init()
------------------------------------------------------------
