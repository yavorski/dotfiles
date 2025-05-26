--- @brief
--- @module "mini.ai"
--- arround/inside text objects
--- text-objects move to class/function/method

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.ai",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", branch = "main" },
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" }
  },
  keys = {
    { "a", mode = { "x", "o" } },
    { "i", mode = { "x", "o" } },
  },
  config = function()
    local ai = require("mini.ai")

    local textobjects = {
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    }

    ai.setup({ n_lines = 420, custom_textobjects = textobjects })
  end
}
