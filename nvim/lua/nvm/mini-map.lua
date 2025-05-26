--- @brief
--- minimap - window with buffer text overview

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.map",
  event = "VeryLazy",
  opts = {
    integrations = nil,
    window = {
      width = 1,
      winblend = 25,
      show_integration_count = false
    },
    symbols = {
      scroll_line = "┃",
      scroll_view = "┃",
    },
  },
  config = function(_, options)
    require("mini.map").setup(options)
    require("mini.map").open()
  end
}
