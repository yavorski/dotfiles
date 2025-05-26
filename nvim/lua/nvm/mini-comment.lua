--- @brief
--- auto comment - [n,v] <gc>

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.comment",
  event = { "BufReadPost", "InsertEnter" },
  opts = { }
}
