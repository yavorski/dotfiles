--- @brief
--- Repositions the cmdline as a centered floating window powered ui2

local Lazy = require("core/lazy")
local border = require("core/border")

Lazy.use {
  src = "https://github.com/yavorski/tiny-cmdline.nvim",
  -- src = "https://github.com/rachartier/tiny-cmdline.nvim",
  event = "VeryLazy",
  config = function()
    --- @type TinyCmdlineConfig
    local options = {
      width = {
        value = 86,
        min = 86,
        max = 96,
      },

      position = {
        x = "50%",
        y = "20%",
      },

      title = {
        enabled = true
      },

      border = border,
      menu_col_offset = 0,
      native_types = { "/", "?" },
      -- on_reposition = require("tiny-cmdline").adapters.blink,
    }

    require("tiny-cmdline").setup(options)
  end
}
