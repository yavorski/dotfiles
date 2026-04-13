--------------------------------------------------------------
-- Lazy
--------------------------------------------------------------
-- vim.pack + lz.n
-- https://github.com/lumen-oss/lz.n
-- https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--------------------------------------------------------------
-- Paths:
-- ~/.local/state/nvim
-- ~/.local/share/nvim
-- ~/.local/share/nvim/site/pack
-- ~/.config/nvim/nvim-pack-lock.json
--------------------------------------------------------------
-- lz.n events:
-- DeferredUIEnter
--------------------------------------------------------------
-- Lazy events:
-- LazyFile = { "BufNewFile", "BufReadPost", "BufWritePre" }
--------------------------------------------------------------
-- https://github.com/neovim/neovim/issues/35550
-- vim.pack serializes `data` via msgpack which cannot handle mixed tables.
--------------------------------------------------------------

--- @class Lazy
local Lazy = {
  --- @type lz.n.pack.Spec[]
  plugins = {},
  --- @type table<string, lz.n.PluginLoadSpec> snapshot of data specs keyed by plugin name
  _specs = {},
}

--- Register a plugin spec to be installed and lazy-loaded via vim.pack + lz.n.
--- @param plugin lz.n.pack.Spec
function Lazy.use(plugin)
  local name = plugin.name or (plugin.src and plugin.src:match("[^/]+$"):gsub("%.git$", ""))
  if name and plugin.data then
    Lazy._specs[name] = plugin.data
  end
  table.insert(Lazy.plugins, plugin)
end

--- Install lz.n via vim.pack.
local function install()
  vim.pack.add({
    "https://github.com/lumen-oss/lz.n"
  })
end

--- Install and load all registered plugins.
local function setup()
  vim.pack.add(Lazy.plugins, { load = require("lz.n").load })
end

--- Install lz.n then load all registered plugins.
function Lazy.init()
  install()
  setup()
end

local augroup = vim.api.nvim_create_augroup("lazy-pack-changed", { clear = true })

--- Register a `PackChanged` autocmd for a plugin.
--- Equivalent of lazy.nvim's `build` field — runs a callback after install or update.
--- Must be called before `Lazy.init()` to catch install events on first startup.
--- @param plugin_name string Name of the plugin (as registered by vim.pack)
--- @param kinds string[] Event kinds to react to: "install", "update", and/or "delete"
--- @param callback fun(data: table) Called with vim.pack event data when the event fires
function Lazy.on_pack_changed(plugin_name, kinds, callback)
  vim.api.nvim_create_autocmd("PackChanged", {
    group = augroup,
    pattern = "*",
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
      if not ev.data.active then vim.cmd.packadd(plugin_name) end
      callback(ev.data)
    end
  })
end

return Lazy
