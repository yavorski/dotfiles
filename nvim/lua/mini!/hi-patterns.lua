local Lazy = require("core/lazy")

-- highlight patterns / display #rrggbb colors
Lazy.use {
  "echasnovski/mini.hipatterns",
  ft = {
    "lua",
    "conf",
    "css",
    "scss",
    "stylus",
    "html",
    "toml",
    "yml",
    "yaml",
    "markdown"
  },
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color()
      }
    })
  end
}
