local LSP = require("lsp/lsp")
local Lazy = require("core/lazy")

Lazy.use {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  dependencies = {
    { "saghen/blink.cmp" }, -- LSP AutoComplete
    { "issafalcon/lsp-overloads.nvim" }, -- Extends native nvim-lsp handlers to allow easier navigation through method overloads
  },
  config = function()
    LSP.init()
  end
}
