--- @brief
--- @module "nvim-treesitter-textobjects"

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-treesitter/nvim-treesitter-textobjects",
  version = "main",
  dependencies = {{ "nvim-treesitter/nvim-treesitter", version = "main" }},
  keys = {
    { "]k", desc = "@class next" },
    { "[k", desc = "@class prev" },
    { "]f", desc = "@function next" },
    { "[f", desc = "@function prev" },
  },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      move = {
        set_jumps = true -- set jumps in jumplist
      }
    })

    local move = require("nvim-treesitter-textobjects.move")

    --- classes
    vim.keymap.set({ "n", "x", "o" }, "]k", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "@class next" })
    vim.keymap.set({ "n", "x", "o" }, "[k", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "@class prev" })

    --- methods ]m [m ]M [M
    --- tree-sitter do not distinct between methods and functions
    --- neovim has builtin ]m [m ]M [M movement but it is not very reliable

    --- functions/methods
    vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "@function next" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "@function prev" })
  end
}
