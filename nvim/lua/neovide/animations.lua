--- @brief
--- NeoVide toggle animations

if not vim.g.neovide then
  return
end

-- neovide default animations
local neovide_position_animation_length = vim.g.neovide_position_animation_length
local neovide_cursor_animation_length = vim.g.neovide_cursor_animation_length
local neovide_cursor_trail_size = vim.g.neovide_cursor_trail_size
local neovide_cursor_animate_in_insert_mode = vim.g.neovide_cursor_animate_in_insert_mode
local neovide_cursor_animate_command_line = vim.g.neovide_cursor_animate_command_line
local neovide_scroll_animation_far_lines = vim.g.neovide_scroll_animation_far_lines
local neovide_scroll_animation_length = vim.g.neovide_scroll_animation_length

local animations = true
local function toggle_animations(notify)
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

  if notify then
    vim.notify("Neovide Animations " .. (animations and "ON" or "OFF"))
  end
end

-- toggle OFF
toggle_animations()

-- user cmd
vim.api.nvim_create_user_command("NeovideToggleAnimations", function() toggle_animations(true) end, { desc = "Neovide Toggle Animations" })
