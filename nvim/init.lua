--- [[ NeoVim ]] ---

--- Perf ---
vim.loader.enable()

--- Settings ---
require("core/ui")
require("core/border")
require("core/options")
require("core/neovide")
require("core/keymaps")
require("core/autocmds")

--- color-scheme ---
require("plugins/color-scheme")

--- Main UI ---
require("plugins/cmd-line")
require("mini/mini-tab-line")
require("mini/mini-status-line")

--- Plugins ---
require("plugins/scope")
require("plugins/fzf-lua")
require("plugins/nvim-tree")

--- Secondary UI ---
require("plugins/marks")
require("plugins/trouble")
require("plugins/which-key")
require("plugins/git-signs")

--- Code Plugins ---
require("plugins/stylus")
require("plugins/auto-tag")
require("plugins/code-diff")
require("plugins/multi-cursor")

--- Tree-Sitter ---
require("plugins/tree-sitter")
require("plugins/tree-sitter-text-objects")

--- Mini Modules ---
require("mini/mini-ai")
require("mini/mini-map")
require("mini/mini-jump")
require("mini/mini-move")
require("mini/mini-misc")
require("mini/mini-icons")
require("mini/mini-pairs")
require("mini/mini-comment")
require("mini/mini-surround")
require("mini/mini-buf-remove")
require("mini/mini-split-join")
require("mini/mini-trail-space")
require("mini/mini-hi-patterns")

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
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  once = true,
  group = vim.api.nvim_create_augroup("local/modules", { clear = true }),
  callback = function()
    require("modules/line-feed")
    require("modules/buffer-only")
    require("modules/smart-close")
    require("modules/smart-escape")
    require("modules/scratch-buffer")
    require("modules/popup-menu")
    require("modules/pack-info")
  end
})

--- Lazy/Zpack init ---
require("core/lazy").init()

--- nvim plugins ---
-- vim.cmd[[packadd nvim.undotree]]
-- vim.cmd[[packadd nvim.difftool]]
