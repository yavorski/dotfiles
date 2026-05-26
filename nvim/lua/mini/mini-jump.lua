--- @brief
--- jump/repeat with f, F, t, T on multiple lines

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.jump",
  opts = {},
  keys = {
    { "f", mode = "n", desc = "Jump forward" },
    { "F", mode = "n", desc = "Jump backward" },
    { "t", mode = "n", desc = "Jump forward till" },
    { "T", mode = "n", desc = "Jump backward till" },
  }
}
