--- @brief
--- jump/repeat with f, F, t, T on multiple lines

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/nvim-mini/mini.jump",
  data = {
    lazy = true,
    keys = {
      { "f", mode = "n", desc = "Jump forward" },
      { "F", mode = "n", desc = "Jump backward" },
      { "t", mode = "n", desc = "Jump forward till" },
      { "T", mode = "n", desc = "Jump backward till" },
    },
    after = function()
      require("mini.jump").setup()
    end
  }
}
