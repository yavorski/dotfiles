local Lazy = require("core/lazy")

-- split/join code blocks, fn args, arrays, tables - [n,v] <sj>
Lazy.use {
  "echasnovski/mini.splitjoin",
  event = "VeryLazy",
  config = function()
    local splitjoin = require("mini.splitjoin")

    splitjoin.setup({
      mappings = { toggle = "sj" },
      join = {
        hooks_post = {
          splitjoin.gen_hook.pad_brackets(),
          splitjoin.gen_hook.del_trailing_separator(),
        }
      }
    })
  end
}
