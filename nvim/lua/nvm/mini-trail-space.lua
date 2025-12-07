--- @brief
--- @module "mini.trailspace"
--- trim/highlight trailing whitespace

local Lazy = require("core/lazy")
local auto_trim_cmd_id = nil

local trim = function()
  MiniTrailspace.trim()
  MiniTrailspace.trim_last_lines()
end

local function enable_autocmd()
  if not auto_trim_cmd_id then
    auto_trim_cmd_id = vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = trim })
  end
end

--- NOTE `.editorconfig` may still trim whitespace even if this autocmd is disabled
local function disable_autocmd()
  if auto_trim_cmd_id then
    vim.api.nvim_del_autocmd(auto_trim_cmd_id)
    auto_trim_cmd_id = nil
  end
end

local function toggle_autocmd()
  if auto_trim_cmd_id then
    disable_autocmd()
    vim.notify("Trailing whitespace autocmd disabled")
  else
    enable_autocmd()
    vim.notify("Trailing whitespace autocmd enabled")
  end
end

Lazy.use {
  "nvim-mini/mini.trailspace",
  event = { "BufNewFile", "BufReadPost", "InsertEnter" },
  config = function()
    require("mini.trailspace").setup()
    enable_autocmd()
    vim.defer_fn(require("mini.trailspace").highlight, 1024)
    vim.api.nvim_create_user_command("TrimTrailingWhiteSpace", trim, { desc = "Trim Trailing White Space" })
    vim.api.nvim_create_user_command("TrimTrailingWhiteSpaceToggle", toggle_autocmd, { desc = "Trim Trailing White Space - Enable/Disable" })
  end
}
