--- @brief
--- Show marks in the sign column
--- TODO - Replace this plugin with https://gh.com/dimtion/guttermarks.nvim/tree/main

local Lazy = require("core/lazy")

Lazy.use {
  "chentoast/marks.nvim",
  keys = {
    { "gmm", function() require("marks").next() end, silent = true, desc = "Go to next mark" },
    { "gmp", function() require("marks").prev() end, silent = true, desc = "Go to prev mark" },
    { "gmd", function() require("marks").delete_buf() end, silent = true, desc = "Delete marks" },
    { "<leader>M", function() vim.defer_fn(require("marks").toggle, 0) end, silent = true, desc = "Mark Toggle" }
  },
  opts = {
    refresh_interval = 2^14,
    default_mappings = false,
  }
}
