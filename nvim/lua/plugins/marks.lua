--- @brief
--- Fork with automatic mark toggling, auto-lettering (a-z), alphabetical reordering, and enhanced actions/commands.
--- Do not rely on using built-in 'm' key.
--- To delete all marks you can use built-in ":delmarks!"

local Lazy = require("core/lazy")

--- @type guttermarks.Config
local options = {
  -- disable plugin override `m` key
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
}

local attached = false
local marks_group = vim.api.nvim_create_augroup("mark-events", { clear = true })

local function init_marks()
  require("guttermarks").setup(options)

  -- `<leader>m` is enabling the plungin on first invocation
  -- reconfigure re-remap the `<leader>m` again after intialization
  vim.schedule(function()
    vim.keymap.set("n", "<leader>m", "<cmd>Marks mark<cr>", { desc = "Mark Toggle" })
  end)

  -- attach `]m` and `[m` keys
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

  -- detach `]m` and `[m` keys
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

Lazy.use {
  src = "https://github.com/yavorski/marks.nvim",
  -- src = "file://" .. vim.fn.expand("~/dev/marks.nvim"),
  cmd = { "Marks" },
  keys = {{ "<leader>m", "<cmd>Marks<cr>", silent = true, remap = false, desc = "Marks Enable" }},
  config = function()
    init_marks()
  end
}
