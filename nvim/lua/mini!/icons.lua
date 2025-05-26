local Lazy = require("core/lazy")

-- mini icons
Lazy.use {
  "echasnovski/mini.icons",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()
  end
}
