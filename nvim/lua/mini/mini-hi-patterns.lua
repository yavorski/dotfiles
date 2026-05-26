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
  "terraform",
}

Lazy.use {
  "nvim-mini/mini.hipatterns",
  ft = filetypes,
  keys = {{ "<leader>H", function() require("mini.hipatterns").toggle() end, desc = "Toggle hi-patterns" }},
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      delay = {
        scroll = 128,
        text_change = 256,
      },
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
        todo  = { pattern = "TODO", group = "MiniHipatternsTodo" },
        note  = { pattern = "NOTE", group = "MiniHipatternsNote" },
        hack  = { pattern = "HACK", group = "MiniHipatternsHack" },
        fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
      }
    })
  end
}
