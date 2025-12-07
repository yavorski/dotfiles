--- @brief
--- Fork with automatic mark toggling, auto-lettering (a-z), alphabetical reordering, and enhanced actions/commands.
--- Do not rely on using built-in 'm' key.
--- To delete all marks you can use built-in ":delmarks!"

local Lazy = require("core/lazy")

Lazy.use {
  "yavorski/marks.nvim",
  -- dir = "~/dev/marks.nvim",
  -- event = { "FileType", "BufNewFile", "BufReadPost", "BufWritePre" },
  cmd = { "Marks" },
  keys = {{ "<leader>m", "<cmd>Marks<cr>", silent = true, remap = false, desc = "Marks Enable" }},
  opts = {
    m_key = false,
    global_mark = {
      enabled = false
    },
    special_mark = {
      enabled = false
    },
    local_mark = {
      enabled = true
    }
  },
  config = function(_, options)
    require("guttermarks").setup(options)

    local attached = false
    local marks_group = vim.api.nvim_create_augroup("mark-events", { clear = true })

    vim.schedule(function()
      vim.keymap.set("n", "<leader>m", "<cmd>Marks mark<cr>", { desc = "Mark Toggle" })
    end)

    vim.api.nvim_create_autocmd("User", {
      group = marks_group,
      pattern = "MarksEnabled",
      callback = function()
        vim.notify("Marks ON")
        if not attached then
          attached = true
          vim.keymap.set("n", "]m", function() require("guttermarks.actions").next_buf_mark(vim.v.count1) end, { desc = "Marks Next" })
          vim.keymap.set("n", "[m", function() require("guttermarks.actions").prev_buf_mark(vim.v.count1) end, { desc = "Marks Prev" })
        end
      end
    })

    vim.api.nvim_create_autocmd("User", {
      group = marks_group,
      pattern = "MarksDisabled",
      callback = function()
        vim.notify("Marks OFF")
        if attached then
          attached = false
          vim.keymap.del("n", "]m")
          vim.keymap.del("n", "[m")
        end
      end
    })
  end
}
