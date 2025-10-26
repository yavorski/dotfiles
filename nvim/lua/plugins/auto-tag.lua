--- @brief
--- @module "autotag.nvim"
--- Auto close/rename html tag
--- Fork with filetype aliases support
--- https://github.com/yavorski/autotag.nvim

local Lazy = require("core/lazy")

local filetypes = {
  "php",
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
        php = "html",
        vue = "html",
        markdown = "html"
      }
    })
  end
}
