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

local function init()
  require("autotag").setup({
    aliases = {
      php = "html",
      vue = "html",
      markdown = "html"
    }
  })
end

Lazy.use {
  src = "git@github.com:yavorski/autotag.nvim.git",
  -- dir = "~/dev/autotag.nvim",
  data = {
    lazy = true,
    after = init,
    ft = filetypes,
  }
}
