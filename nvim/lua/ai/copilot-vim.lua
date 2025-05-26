local Lazy = require("core/lazy")
local Copilot = require("ai/copilot")

Lazy.use {
  "github/copilot.vim",
  cmd = "Copilot",
  keys = {
    { "<leader>ct", Copilot.toggle, silent = true, desc = "[] Copilot Enable/Disable" },
    { "<leader>cp", "<cmd>Copilot panel<CR>", mode = { "n", "v" }, silent = true, desc = "[] Copilot Panel [10]" },
    { "<leader>cs", "<cmd>Copilot status<CR>", mode = { "n", "v" }, silent = true, desc = "[] Copilot Start/Status" },
  },
  config = function()
    vim.keymap.set("i", "<A-t>", Copilot.toggle, { silent = true, desc = "Copilot Toggle"})
    vim.keymap.set("i", "<A-f>", Copilot.accept_word, { silent = true, desc = "Copilot Accept Word" })
    vim.keymap.set("i", "<C-e>", Copilot.accept_line, { silent = true, desc = "Copilot Accept Line" })
    vim.keymap.set("i", "<A-]>", "<Plug>(copilot-next)", { silent = true, desc = "Copilot Next" })
    vim.keymap.set("i", "<A-[>", "<Plug>(copilot-previous)", { silent = true, desc = "Copilot Prev" })
    vim.keymap.set("i", "<A-ESC>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot Dismiss" })
    vim.keymap.set("i", "<A-F13>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot Dismiss" })
    vim.keymap.set("i", "<A-\\>", "<Plug>(copilot-suggest)", { silent = true, desc = "Copilot Request Suggestion" })
    vim.keymap.set("i", "<A-CR>", "copilot#Accept('<CR>')", { expr = true, replace_keycodes = false, silent = true, desc = "Copilot Accept" })
  end,
  init = function()
    vim.g.copilot_enabled = true
    vim.g.copilot_no_tab_map = true
    vim.cmd[[autocmd FileType copilot setlocal norelativenumber]]
    vim.api.nvim_create_autocmd("User", { pattern = "BlinkCmpMenuOpen", callback = Copilot.buf_disable })
    vim.api.nvim_create_autocmd("User", { pattern = "BlinkCmpMenuClose", callback = Copilot.buf_enable })
  end
}
