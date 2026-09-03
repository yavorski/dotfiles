--- @brief
--- Map <C-q>
--- smart close tabs and buffers

--- check if window is a normal (non-floating, focusable) window
local function is_normal_window(window_handle)
  if not vim.api.nvim_win_is_valid(window_handle) then
    return false
  end
  local config = vim.api.nvim_win_get_config(window_handle)
  return config.relative == "" and config.focusable ~= false
end

--- filter out sidebar/tree filetypes so splits are counted correctly
local function is_user_window(window_handle)
  return vim.bo[vim.api.nvim_win_get_buf(window_handle)].filetype ~= "NvimTree"
end

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

--- smart close
local function smart_close()
  local current_buff = vim.api.nvim_get_current_buf()
  -- NOTE: listed_buffs is global; user_windows is scoped to the current tabpage.
  -- The split check below is intentionally per-tabpage; the buffer check is global.
  local listed_buffs = vim.fn.getbufinfo({ buflisted = 1 })
  local normal_windows = vim.tbl_filter(is_normal_window, vim.api.nvim_tabpage_list_wins(0))
  local user_windows = vim.tbl_filter(is_user_window, normal_windows)
  local is_in_split = #user_windows > 1

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

  if is_in_split then
    if is_buffer_in_split() then
      return vim.cmd("close")
    end
    return vim.cmd("bdelete")
  end

  if #listed_buffs > 1 then
    vim.cmd("bprevious")
    return vim.cmd("bdelete " .. current_buff)
  end

  if vim.fn.tabpagenr("$") > 1 then
    return vim.cmd("tabclose")
  end

  vim.notify("Last tab or buffer!")
end

-- set keymap
vim.keymap.set("n", "<C-q>", smart_close, { silent = true, desc = "Close buffer if not last" })
