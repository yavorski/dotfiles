--- @brief
--- mini icons

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/nvim-mini/mini.icons",
  data = {
    lazy = true,
    event = "DeferredUIEnter",
    after = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end
  }
}
