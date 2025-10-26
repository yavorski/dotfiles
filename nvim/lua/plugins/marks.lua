--- @brief
--- Fork with automatic mark toggling, auto-lettering (a-z), alphabetical reordering, and enhanced actions/commands.
--- Do not rely on using built-in 'm' key.
--- To delete all marks you can use built-in ":delmarks!"

local Lazy = require("core/lazy")

Lazy.use {
  "yavorski/marks.nvim",
  -- dir = "~/dev/marks.nvim",
  -- event = { "BufNewFile", "BufReadPost", "BufWritePre" },
  cmd = { "Marks" },
  opts = {
    m_key = false,
    global_mark = {
      enabled = false
    }
  },
  config = function(_, options)
    require("guttermarks").setup(options)
    vim.keymap.set("n", "<leader>m", "<cmd>Marks mark<cr>", { desc = "Mark Toggle" })
    vim.keymap.set("n", "]m", function() require("guttermarks.actions").next_buf_mark(vim.v.count1) end, { desc = "Marks Next" })
    vim.keymap.set("n", "[m", function() require("guttermarks.actions").prev_buf_mark(vim.v.count1) end, { desc = "Marks Prev" })
  end
}
