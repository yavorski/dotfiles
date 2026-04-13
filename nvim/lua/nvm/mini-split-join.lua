--- @brief
--- split/join code blocks, fn args, arrays, tables - [n,v] <sj>

local Lazy = require("core/lazy")

Lazy.use {
  src = "https://github.com/nvim-mini/mini.splitjoin",
  data = {
    lazy = true,
    keys = {
      { "sj", function() require("mini.splitjoin").toggle() end, silent = true, desc = "Split/Join" }
    },
    after = function()
      local splitjoin = require("mini.splitjoin")

      splitjoin.setup({
        mappings = {
          toggle = "sj"
        },
        join = {
          hooks_post = {
            splitjoin.gen_hook.pad_brackets(),
            splitjoin.gen_hook.del_trailing_separator(),
          }
        }
      })
    end
  }
}
