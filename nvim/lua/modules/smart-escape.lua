-- Map <esc>
-- Close all floating windows
-- Close quickfix list, location list, noice, trouble

-- escape fn
local function escape()
  vim.cmd("Noice dismiss")
  vim.cmd("silent! cclose | lclose")

  if vim.snippet.active() then
    return vim.snippet.stop()
  end

  if vim.g.NvimTreeRequired == 1 then
    vim.cmd("silent! 1fclose")
  else
    vim.cmd("silent! fclose!")
  end

  if MiniMap ~= nil then MiniMap.open() end
  if MiniJump ~= nil and MiniJump.state.jumping then MiniJump.stop_jumping() end
end

-- map <esc> key
vim.keymap.set("n", "<esc>", escape, { silent = true, noremap = true, desc = "Escape" })
