------------------------------------------------------------
-- Lazy
------------------------------------------------------------
-- ~/.cache/nvim
-- ~/.local/share/nvim/lazy
-- ~/.local/state/nvim/lazy
-- ~/.config/nvim/lazy-lock.json
------------------------------------------------------------
-- nvim --headless "+Lazy! sync" +qa
------------------------------------------------------------

local Lazy = {
  plugins = {},
  path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  repository = "https://github.com/folke/lazy.nvim.git",
  --- @module "lazy"
  --- @type LazyConfig
  config = {
    ui = {
      border = _G.window_border,
      backdrop = 100
    },
    rocks = {
      enabled = false
    },
    install = {
      missing = true,
      colorscheme = { "default" }
    },
    defaults = {
      lazy = true, -- lazy load plugins by default
      version = false, -- always use the latest git commit
    },
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "tutor",
          "tohtml",
          "tarPlugin",
          "zipPlugin",
          "netrwPlugin",
        }
      }
    }
  }
}

-- "LazyFile"
-- Lazy.LazyFile = { "BufNewFile", "BufReadPost", "BufWritePre" }

--- Install "lazy" plugin manager
function Lazy.install()
  if not vim.uv.fs_stat(Lazy.path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", Lazy.repository, Lazy.path })
  end

  -- run time path
  vim.opt.rtp:prepend(Lazy.path)
end

--- Add lazy plugin
--- @param plugin LazyPluginSpec
function Lazy.use(plugin)
  table.insert(Lazy.plugins, plugin)
end

--- Install and setup all configured plugins
function Lazy.setup()
  require("lazy").setup(Lazy.plugins, Lazy.config)
end

--- Install "lazy" and all plugins
function Lazy.init()
  Lazy.install()
  Lazy.setup()
end

return Lazy
