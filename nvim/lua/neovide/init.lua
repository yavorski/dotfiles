--- @brief
--- NeoVide

local system = require("core/system")

if not vim.g.neovide then
  return
end

vim.g.neovide_remember_window_size = true
vim.g.neovide_progress_bar_enabled = false

-- intel one mono
vim.opt.linespace = system.is_wsl_or_windows and 2 or 1

-- jet brains mono
-- vim.opt.linespace = is_wsl_or_windows and 2 or 3

-- neovide session
require("neovide.session")

-- neovide animations
require("neovide/animations")

-- fzf-lua paste fix
vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end, { noremap = true, silent = true })
