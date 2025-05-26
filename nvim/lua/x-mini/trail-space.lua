--- @brief
--- trim/highlight trailing whitespace

local Lazy = require("core/lazy")

Lazy.use {
  "echasnovski/mini.trailspace",
  event = { "BufReadPost", "InsertEnter" },
  config = function()
    require("mini.trailspace").setup({})

    local trim = function()
      MiniTrailspace.trim()
      MiniTrailspace.trim_last_lines()
    end

    vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = trim })
    vim.api.nvim_create_user_command("TrimTralingWhiteSpace", trim, { desc = "Trim Trailing White Space" })
  end
}
