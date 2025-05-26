--- @brief
--- Map <C-q>
--- smart close tabs and buffers

--- check if window is user valid window
local is_valid_window = function(window_handle)
  if not vim.api.nvim_win_is_valid(window_handle) then
    return false
  end
  local config = vim.api.nvim_win_get_config(window_handle)
  return config.relative == "" and config.focusable ~= false
end

--- smart close
--- TODO -- handle nvim-tree
local function smart_close()
  local listed_buffs = vim.fn.getbufinfo({ buflisted = 1 })
  local valid_windows = vim.tbl_filter(is_valid_window, vim.api.nvim_tabpage_list_wins(0))

  if vim.bo.modified then
    return vim.notify("Buffer modified!")
  end

  if vim.bo.filetype == "help" then
    return vim.cmd("helpclose")
  end

  if vim.fn.getcmdwintype() ~= "" then
    return vim.cmd("quit")
  end

  if vim.bo.buftype == "terminal" then
    return vim.cmd("bdelete!")
  end

  if vim.bo.filetype == "NvimTree" then
    return vim.cmd("NvimTreeClose")
  end

  if #listed_buffs > 1 then
    return vim.cmd("bdelete | blast")
  end

  if #valid_windows > 1 and #listed_buffs > 1 then
    return vim.cmd("bdelete | blast")
  end

  if vim.fn.tabpagenr("$") > 1 then
    return vim.cmd("tabclose")
  end

  vim.notify("Last tab or buffer!")
end

-- set keymap
vim.keymap.set("n", "<C-q>", smart_close, { silent = true, desc = "Close buffer if not last" })
