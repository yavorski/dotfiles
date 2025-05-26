local Lazy = require("core/lazy")

Lazy.use {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } }
  },
  cmd = { "DBUI", "DBUIToggle" },
  keys = {{ [[<leader>\d]], "<cmd>DBUIToggle<cr>", silent = true, desc = "DBUI Toggle" }},
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
    -- vim.cmd[[autocmd FileType dbout setlocal nofoldenable foldmethod=manual]]
  end
}
