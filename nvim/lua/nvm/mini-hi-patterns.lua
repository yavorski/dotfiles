--- @brief
--- highlight patterns / display #rrggbb colors

local Lazy = require("core/lazy")

local filetypes = {
  "lua",
  "ini",
  "dosini",
  "confini",
  "conf",
  "css",
  "scss",
  "stylus",
  "html",
  "toml",
  "yml",
  "yaml",
  "kitty",
  "ghostty",
  "markdown",
}

Lazy.use {
  "nvim-mini/mini.hipatterns",
  ft = filetypes,
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color()
      }
    })
  end
}
