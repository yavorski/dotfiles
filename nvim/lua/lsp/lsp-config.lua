--- @brief
--- plugin initialization
--- https://github.com/neovim/nvim-lspconfig

local LSP = require("lsp/lsp")
local Lazy = require("core/lazy")

Lazy.use {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" }, -- AutoComplete
  event = {
    "BufNewFile",
    "BufReadPost",
    "BufWritePost",
  },
  config = function()
    LSP.init()
  end
}
