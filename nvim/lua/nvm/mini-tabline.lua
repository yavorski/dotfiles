--- @brief
--- mini.tabline - default setup

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.tabline",
  lazy = false,
  priority = 512,
  config = function()
    require("mini.tabline").setup()
  end
}
