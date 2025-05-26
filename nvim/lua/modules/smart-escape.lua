------------------------------------------------------------
-- Map <esc>
-- Map <F1> to <ESC>
-- close all floating windows
-- close quickfix list, location list, trouble & noice
------------------------------------------------------------

vim.cmd("map <F1> <esc>")
vim.cmd("map! <F1> <esc>")

-- close quickfix/location list
local function close_qf_loc_list()
  -- Check if the quickfix list is open
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
  end
  -- Check if the location list is open
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd("lclose")
  end
end

-- escape fn
local function escape()
  close_qf_loc_list()

  vim.cmd("Noice dismiss")
  vim.cmd(vim.g.NvimTreeRequired == 1 and "silent! fclose" or "silent! fclose!")

  if vim.snippet.active() then
    vim.snippet.stop()
  end

  if MiniMap ~= nil then MiniMap.open() end
  if MiniJump ~= nil and MiniJump.state.jumping then MiniJump.stop_jumping() end
end

-- map <esc> key
vim.keymap.set("n", "<esc>", escape, { silent = true, noremap = true, desc = "Escape" })
