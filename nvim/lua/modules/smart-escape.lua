-- Map <esc>
-- Close floating windows, quickfix & location list

local KEEP_FILETYPES = {
  minimap = true,
  NvimTree = true,
}

local function escape()
  vim.cmd("silent! cclose | lclose")

  if vim.snippet.active() then
    return vim.snippet.stop()
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      local ft = vim.api.nvim_get_option_value("filetype", {
        buf = vim.api.nvim_win_get_buf(win)
      })

      if not KEEP_FILETYPES[ft] then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end

  if MiniMap ~= nil then
    MiniMap.open()
  end

  if MiniJump ~= nil and MiniJump.state.jumping then
    MiniJump.stop_jumping()
  end
end

-- map <esc> key
vim.keymap.set("n", "<esc>", escape, { silent = true, desc = "Escape" })
