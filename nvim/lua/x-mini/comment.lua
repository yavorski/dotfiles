--- @brief
--- auto comment - [n,v] <gc>

local Lazy = require("core/lazy")

Lazy.use {
  "echasnovski/mini.comment",
  event = { "BufReadPost", "InsertEnter" },
  opts = { }
}
