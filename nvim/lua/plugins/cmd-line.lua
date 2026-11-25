--- @brief
--- Repositions the cmdline as a centered floating window powered ui2

local Lazy = require("core/lazy")

--- @type TinyCmdlineConfig
local options = {
  width = {
    min = 86,
    max = 96,
    value = 86,
  },
  position = {
    x = "50%",
    y = "20%",
  },
  title = {
    enabled = true,
  },
  menu_col_offset = 0,
  native_types = vim.fn.has("nvim-0.13") and { } or { "/", "?" },
}

Lazy.use {
  src = "https://github.com/rachartier/tiny-cmdline.nvim",
  -- src = "file://" .. vim.fn.expand("~/dev/nvim-plugins/tiny-cmdline.nvim"),
  event = "VeryLazy",
  config = function()
    require("tiny-cmdline").setup(options)
  end,
}
