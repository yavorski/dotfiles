--- @brief
--- auto comment - [n,v] <gc>

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/nvim-mini/mini.comment",
  data = {
    lazy = true,
    event = { "BufReadPost", "InsertEnter" },
    after = function()
      require("mini.comment").setup()
    end
  }
}
