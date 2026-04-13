--- @brief
--- Scope buffers to tabs

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/tiagovla/scope.nvim",
  data = {
    lazy = true,
    event = "DeferredUIEnter",
    after = function()
      require("scope").setup()
    end
  }
}
