--- @brief
--- surround - add, delete, replace, find, highlight - [n,v] <sa> <sd> <sr>

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/nvim-mini/mini.surround",
  data = {
    lazy = true,
    event = { "BufReadPost", "InsertEnter" },
    after = function()
      require("mini.surround").setup()
    end
  }
}
