--- @brief
--- surround - add, delete, replace, find, highlight - [n,v] <sa> <sd> <sr>

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.surround",
  event = { "BufReadPost", "InsertEnter" },
  opts = { }
}
