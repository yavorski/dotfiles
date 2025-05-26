--- [[ NeoVim ]] ---
--------------------

--- Core ---
require("core/options")
require("core/border")
require("core/neovide")
require("core/keymaps")
require("core/autocmds")

--- Plugins ---
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

--- Tree-Sitter ---
require("plugins/tree-sitter")
require("plugins/tree-sitter-text-objects")

--- Mini Modules ---
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

--- AI Modules ---
require("ai/copilot-vim")
require("ai/code-companion")

--- LSP Modules ---
require("lsp/blink")
require("lsp/lazy-dev")
require("lsp/lsp-config")
require("lsp/diagnostics")
require("lsp/typescript-tools")
-- require("lsp/dadbod")
-- require("lsp/roslyn")
-- require("lsp/rust-tools")

--- Local Lua Modules ---
require("modules/line-feed")
require("modules/popup-menu")
require("modules/buffer-only")
require("modules/smart-close")
require("modules/smart-escape")

--- Lazy init ---
require("core/lazy").init()
