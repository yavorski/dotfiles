--- @brief
--- NeoVide

local system = require("core/system")

if not vim.g.neovide then
  return
end

vim.g.neovide_remember_window_size = true
vim.g.neovide_progress_bar_enabled = false

-- intel one mono
vim.opt.linespace = system.is_wsl_or_windows and 4 or 1

-- jet brains mono
-- vim.opt.linespace = is_wsl_or_windows and 2 or 3

-- fix path
require("neovide/path")

-- neovide session
require("neovide.session")

-- neovide animations
require("neovide/animations")

-- copy/paste
local function copy()
  vim.cmd([[normal! "+y]])
end

local function paste()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end

vim.keymap.set({ "v" }, "<C-S-c>", copy, { silent = true, desc = "Copy" })
vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-S-v>", paste, { silent = true, desc = "Paste" })
