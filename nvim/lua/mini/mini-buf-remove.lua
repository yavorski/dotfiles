--- @brief
--- delete buffers without losing window layout

local Lazy = require("core/lazy")

--- true if the current buffer is displayed in more than one window in the current tab
local function is_buffer_in_split()
  local count = 0
  local curbuf = vim.api.nvim_get_current_buf()

  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(w) == curbuf then
      count = count + 1
      if count > 1 then
        return true
      end
    end
  end

  return false
end

--- delete the current (or given) buffer while preserving window layout
--- @param opts vim.api.keyset.create_user_command.command_args
local function bdelete(opts)
  if vim.bo.filetype == "NvimTree" then
    return vim.cmd("NvimTreeClose")
  end
  if is_buffer_in_split() then
    return vim.cmd("close")
  end
  require("mini.bufremove").delete(tonumber(opts.args) or 0, opts.bang)
end

--- wipeout the current (or given) buffer while preserving window layout
--- @param opts vim.api.keyset.create_user_command.command_args
local function bwipeout(opts)
  if vim.bo.filetype == "NvimTree" then
    return vim.cmd("NvimTreeClose")
  end
  if is_buffer_in_split() then
    return vim.cmd("close")
  end
  require("mini.bufremove").wipeout(tonumber(opts.args) or 0, opts.bang)
end

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
    vim.api.nvim_create_user_command("Bdelete", bdelete, { bang = true, nargs = "?" })
    vim.api.nvim_create_user_command("Bwipeout", bwipeout, { bang = true, nargs = "?" })
  end
}
