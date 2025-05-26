--- @brief
--- auto pairs

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.pairs",
  event = "InsertEnter",
  opts = { }
}
