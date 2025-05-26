local Lazy = require("core/lazy")

-- arround/inside text objects
-- text-objects move to class/function/method
Lazy.use {
  "echasnovski/mini.ai",
  dependencies = {
    -- TODO -- switch to main branch
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-textobjects" }
  },
  keys = {
    { "a", mode = { "x", "o" } },
    { "i", mode = { "x", "o" } },
    { "[[", desc = "Prev start @class" },
    { "]]", desc = "Next start @class" },
    { "[]", desc = "Prev end @class" },
    { "][", desc = "Next end @class" },
    { "[f", desc = "Prev start @function" },
    { "]f", desc = "Next start @function" },
    { "[F", desc = "Prev end @function" },
    { "]F", desc = "Next end @function" },
  },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 420,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      },
    }
  end,
  config = function(_, options)
    require("mini.ai").setup(options)
    --- @diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start     = { ["]]"] = "@class.outer", ["]f"] = "@function.outer" },
          goto_next_end       = { ["]["] = "@class.outer", ["]F"] = "@function.outer" },
          goto_previous_start = { ["[["] = "@class.outer", ["[f"] = "@function.outer" },
          goto_previous_end   = { ["[]"] = "@class.outer", ["[F"] = "@function.outer" },
        }
      }
    })
  end
}
