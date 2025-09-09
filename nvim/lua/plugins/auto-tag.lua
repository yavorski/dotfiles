--- @brief
--- @module "autotag.nvim"
--- Auto close/rename html tag
--- https://github.com/yavorski/autotag.nvim
--- NOTE this plugin does support dot repeat, so it should work properly with multicursor

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
