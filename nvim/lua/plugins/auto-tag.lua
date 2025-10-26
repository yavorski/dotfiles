--- @brief
--- @module "autotag.nvim"
--- Auto close/rename html tag
--- https://github.com/yavorski/autotag.nvim

local Lazy = require("core/lazy")

local filetypes = {
  "vue",
  "xml",
  "html",
  "razor",
  "cshtml",
  "markdown",
  "htmlangular",
  "typescriptreact",
  "javascriptreact",
}

Lazy.use {
  "git@github.com:yavorski/autotag.nvim.git",
  -- dir = "~/dev/autotag.nvim",
  ft = filetypes,
  config = function()
    require("autotag").setup({
      aliases = {
        vue = "html",
        markdown = "html"
      }
    })
  end
}
