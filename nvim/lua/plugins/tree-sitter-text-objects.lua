--- @brief
--- @module "nvim-treesitter-textobjects"

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = {{ "nvim-treesitter/nvim-treesitter", branch = "main" }},
  keys = {
    { "]c", desc = "@class next" },
    { "[c", desc = "@class prev" },
    { "]C", desc = "@class next end" },
    { "[C", desc = "@class prev end" },

    { "]f", desc = "@function next" },
    { "[f", desc = "@function prev" },
    { "]F", desc = "@function next end" },
    { "[F", desc = "@function prev end" },
  },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      move = {
        set_jumps = true -- set jumps in jumplist
      }
    })

    local move = require("nvim-treesitter-textobjects.move")

    --- classes
    --- NOTE do not assign "]c" and "[c" in diff mode
    vim.keymap.set({ "n", "x", "o" }, "]c", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else move.goto_next_start("@class.outer", "textobjects") end end, { desc = "@class next" })
    vim.keymap.set({ "n", "x", "o" }, "[c", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else move.goto_previous_start("@class.outer", "textobjects") end end, { desc = "@class prev" })
    vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "@class next end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "@class prev end" })

    --- methods ]m [m ]M [M
    --- tree-sitter do not distinct between methods and functions
    --- neovim has builtin ]m [m ]M [M movement but it is not very reliable

    --- functions/methods
    vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "@function next" })
    vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "@function prev" })
    vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "@function next end" })
    vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "@function prev end"})
  end
}
