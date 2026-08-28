--- @brief
--- Scope buffers to tabs

local Lazy = require("core/lazy")

Lazy.use {
  "tiagovla/scope.nvim",
  opts = {},
  lazy = not vim.g.neovide,
  event = not vim.g.neovide and "VeryLazy" or nil,
}
