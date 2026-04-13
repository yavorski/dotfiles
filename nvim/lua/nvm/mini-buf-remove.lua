--- @brief
--- delete buffers without losing window layout

local Lazy = require("core/lazy")

local function init()
  vim.api.nvim_create_user_command("Bdelete", function(opts)
    if vim.bo.filetype == "NvimTree" then
      return vim.cmd("NvimTreeClose")
    end
    require("mini.bufremove").delete(tonumber(opts.args) or 0, opts.bang)
  end, { bang = true, nargs = "?" })

  vim.api.nvim_create_user_command("Bwipeout", function(opts)
    if vim.bo.filetype == "NvimTree" then
      return vim.cmd("NvimTreeClose")
    end
    require("mini.bufremove").wipeout(tonumber(opts.args) or 0, opts.bang)
  end, { bang = true, nargs = "?" })
end

Lazy.use {
  src = "https://github.com/nvim-mini/mini.bufremove",
  data = {
    lazy = true,
    after = init,
    cmd = {
      "Bdelete",
      "Bwipeout"
    },
    keys = {
      { "<leader>q", "<cmd>Bdelete<cr>", silent = true, desc = "Quit Buffer" },
      { "<leader>Q", "<cmd>Bwipeout<cr>", silent = true, desc = "Wipeout Buffer" }
    }
  }
}
