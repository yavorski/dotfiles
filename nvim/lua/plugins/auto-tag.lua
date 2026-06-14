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
  src = "https://github.com/yavorski/autotag.nvim",
  -- src = "file://" .. vim.fn.expand("~/dev/nvim-plugins/autotag.nvim"),
  version = "main",
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
