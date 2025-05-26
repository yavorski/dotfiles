--- @brief
--- surround - add, delete, replace, find, highlight - [n,v] <sa> <sd> <sr>

local Lazy = require("core/lazy")

Lazy.use {
  "echasnovski/mini.surround",
  event = { "BufReadPost", "InsertEnter" },
  opts = { }
}
