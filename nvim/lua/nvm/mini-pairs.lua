--- @brief
--- auto pairs

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/nvim-mini/mini.pairs",
  data = {
    lazy = true,
    event = "InsertEnter",
    after = function()
      require("mini.pairs").setup()
    end
  }
}
