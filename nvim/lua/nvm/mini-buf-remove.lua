--- @brief
--- delete buffers without losing window layout

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.bufremove",
  cmd = {
    "Bdelete",
    "Bwipeout"
  },
  keys = {
    { "<leader>q", "<cmd>Bdelete<cr>", silent = true, desc = "Quit Buffer" },
    { "<leader>Q", "<cmd>Bwipeout<cr>", silent = true, desc = "Wipeout Buffer" }
  },
  config = function()
    vim.api.nvim_create_user_command("Bdelete", function(opts) require("mini.bufremove").delete(tonumber(opts.args) or 0, opts.bang) end, { bang = true, nargs = "?" })
    vim.api.nvim_create_user_command("Bwipeout", function(opts) require("mini.bufremove").wipeout(tonumber(opts.args) or 0, opts.bang) end, { bang = true, nargs = "?" })
  end
}
