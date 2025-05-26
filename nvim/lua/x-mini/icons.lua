--- @brief
--- mini icons

local Lazy = require("core/lazy")

Lazy.use {
  "echasnovski/mini.icons",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()
  end
}
