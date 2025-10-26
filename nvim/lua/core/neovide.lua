------------------------------------------------------------
-- NeoVide
------------------------------------------------------------
local system = require("core/system")

if not vim.g.neovide then
  return
end

vim.g.neovide_remember_window_size = true

-- intel one mono
vim.opt.linespace = system.is_wsl_or_windows and 2 or 1

-- jet brains mono
-- vim.opt.linespace = is_wsl_or_windows and 2 or 3

-- fzf-lua paste fix
vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end, { noremap = true, silent = true })

-- neovide default animations
local neovide_position_animation_length = vim.g.neovide_position_animation_length;
local neovide_cursor_animation_length = vim.g.neovide_cursor_animation_length;
local neovide_cursor_trail_size = vim.g.neovide_cursor_trail_size;
local neovide_cursor_animate_in_insert_mode = vim.g.neovide_cursor_animate_in_insert_mode;
local neovide_cursor_animate_command_line = vim.g.neovide_cursor_animate_command_line;
local neovide_scroll_animation_far_lines = vim.g.neovide_scroll_animation_far_lines;
local neovide_scroll_animation_length = vim.g.neovide_scroll_animation_length;

local animations = true
local function toggle_animations()
  animations = not animations

  if animations then
    vim.g.neovide_position_animation_length = neovide_position_animation_length
    vim.g.neovide_cursor_animation_length = neovide_cursor_animation_length
    vim.g.neovide_cursor_trail_size = neovide_cursor_trail_size
    vim.g.neovide_cursor_animate_in_insert_mode = neovide_cursor_animate_in_insert_mode
    vim.g.neovide_cursor_animate_command_line = neovide_cursor_animate_command_line
    vim.g.neovide_scroll_animation_far_lines = neovide_scroll_animation_far_lines
    vim.g.neovide_scroll_animation_length = neovide_scroll_animation_length
  else
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00
  end

  vim.notify("Neovide Animations " .. (animations and "ON" or "OFF"))
end

-- user cmd
vim.api.nvim_create_user_command("NeovideToggleAnimations", toggle_animations, { desc = "Neovide Toggle Animations" })
