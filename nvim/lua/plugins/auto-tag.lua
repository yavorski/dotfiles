--- @brief
--- @module "autotag.nvim"
--- Auto close/rename html tag
--- https://github.com/yavorski/autotag.nvim

local Lazy = require("core/lazy")

local filetypes = {
  "xml",
  "html",
  "razor",
  "cshtml",
  "htmlangular",
  "typescriptreact",
  "javascriptreact",
}

Lazy.use {
  "git@github.com:yavorski/autotag.nvim.git",
  -- dir = "~/dev/autotag.nvim",
  ft = filetypes,
  config = function()
    require("autotag").setup()
  end
}
