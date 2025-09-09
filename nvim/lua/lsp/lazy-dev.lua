--- @brief
--- This plugin will setup "lua_ls" for neovim lua/config development.
--- It will append the "lazy" loaded plugins on demand to the "workspace.library".
--- DO NOT create ".luarc.json"
--- Include the "workspace.library" entries here.
--- DO NOT Include the "workspace.library" entries in the LSP config.
--- Run "LazyDev debug" to see what is currently included.

local Lazy = require("core/lazy")

Lazy.use {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "lazy.nvim", words = { "Lazy" } },
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "deps/mini.test/lua", words = { "MiniTest" } },
    },
    integrations = {
      cmp = false,
      lspconfig = true,
    }
  }
}
