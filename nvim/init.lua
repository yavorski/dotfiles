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
require("plugins/multi-cursor")
-- require("plugins/marks")
-- require("plugins/diff-view")

--- Tree-Sitter ---
require("plugins/tree-sitter")
require("plugins/tree-sitter-text-objects")

--- Mini Modules ---
require("nvm/mini-ai")
require("nvm/mini-map")
require("nvm/mini-diff")
require("nvm/mini-jump")
require("nvm/mini-move")
require("nvm/mini-misc")
require("nvm/mini-icons")
require("nvm/mini-pairs")
require("nvm/mini-comment")
require("nvm/mini-surround")
require("nvm/mini-buf-remove")
require("nvm/mini-split-join")
require("nvm/mini-trail-space")
require("nvm/mini-hi-patterns")
-- require("nvm/mini-indent-scope")

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
require("modules/scratch-buffer")

--- Lazy init ---
require("core/lazy").init()
