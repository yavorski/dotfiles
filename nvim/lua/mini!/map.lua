local Lazy = require("core/lazy")

-- minimap - window with buffer text overview
Lazy.use {
  "echasnovski/mini.map",
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
