------------------------------------------------------------
-- Zpack Lazy
------------------------------------------------------------
-- ~/.cache/nvim
-- ~/.local/share/nvim/...
-- ~/.local/state/nvim/...
-- ~/.config/nvim/nvim-pack-lock.json
------------------------------------------------------------
-- local plugins can be symlinked in:
-- ~/.local/share/nvim/site/pack/mine/opt/...
------------------------------------------------------------
-- LazyFile = { "BufNewFile", "BufReadPost", "BufWritePre" }
------------------------------------------------------------

local Lazy = {
  plugins = {}
}

--- Install "zpack" plugin manager
function Lazy.install()
  vim.pack.add({ "https://github.com/yavorski/zpack.nvim" })
end

--- Add lazy plugin
--- @param plugin zpack.Spec
function Lazy.use(plugin)
  table.insert(Lazy.plugins, plugin)
end

--- Install and setup all configured plugins
function Lazy.setup()
  require("zpack").setup({
    --- @type zpack.Spec[]
    spec = Lazy.plugins,

    --- @type string
    cmd_name = "Lazy",

    --- @type zpack.Config.Defaults
    defaults = {
      cond = nil,
      lazy = true,
      confirm = true,
    },

    --- @type zpack.Config.Performance
    performance = {
      vim_loader = true
    },

    --- @type zpack.Config.Profiling
    profiling = {
      loader = false,
      require = false
    },
  })
end

--- Install "lazy" and all plugins
function Lazy.init()
  Lazy.install()
  Lazy.setup()
end

return Lazy
