--- [[ NeoVim ]] ---

--- Core Settings ---
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
require("x-mini/ai")
require("x-mini/map")
require("x-mini/diff")
require("x-mini/jump")
require("x-mini/move")
require("x-mini/misc")
require("x-mini/icons")
require("x-mini/pairs")
require("x-mini/comment")
require("x-mini/surround")
require("x-mini/buf-remove")
require("x-mini/split-join")
require("x-mini/trail-space")
require("x-mini/hi-patterns")
-- require("x-mini/indent-scope")

--- AI Modules ---
require("ai/copilot-vim")
require("ai/code-companion")

--- LSP Modules ---
require("lsp/blink")
require("lsp/roslyn")
require("lsp/lazy-dev")
require("lsp/overloads")
require("lsp/lsp-config")
require("lsp/diagnostics")
require("lsp/typescript-tools")
-- require("lsp/dadbod")
-- require("lsp/rust-tools")

--- Local Lua Modules ---
require("modules/line-feed")
require("modules/popup-menu")
require("modules/buffer-only")
require("modules/smart-close")
require("modules/smart-escape")

--- Lazy init ---
require("core/lazy").init()
