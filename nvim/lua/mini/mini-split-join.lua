--- @brief
--- split/join code blocks, fn args, arrays, tables - [n,v] <sj>

local Lazy = require("core/lazy")

-- join with padding brackets -> ( a, b, c )
local function sj()
  require("mini.splitjoin").toggle()
end

-- join without padding brackets -> (a, b, c)
local function sJ()
  require("mini.splitjoin").toggle({
    join = {
      hooks_post = {
        require("mini.splitjoin").gen_hook.del_trailing_separator()
      }
    }
  })
end

local function init_split_join()
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

Lazy.use {
  "nvim-mini/mini.splitjoin",
  keys = {
    { "sj", sj, silent = true, desc = "Split/Join" },
    { "sJ", sJ, silent = true, desc = "Split/Join" }
  },
  config = init_split_join
}
