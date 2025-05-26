------------------------------------------------------------
-- NeoVide
------------------------------------------------------------
local system = require("core/system")

if vim.g.neovide then
  vim.g.neovide_remember_window_size = true

  -- intel one mono
  vim.opt.linespace = system.is_wsl_or_windows and 2 or 1

  -- jet brains mono
  -- vim.opt.linespace = is_wsl_or_windows and 2 or 3

  -- fzf-lua paste fix
  vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end, { noremap = true, silent = true })
end
