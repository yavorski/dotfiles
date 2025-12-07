--- @brief
--- minimap - window with buffer text overview

local Lazy = require("core/lazy")

--- minimal scrollbar only
local function setup_minimal()
  local map = require("mini.map")
  local options = {
    integrations = nil,
    window = {
      width = 1,
      winblend = 25,
      show_integration_count = false
    },
    symbols = {
      scroll_line = "┃",
      scroll_view = "┃",
    }
  }

  map.setup(options)
  map.open(options)
end

--- map with git integrations
local function setup_with_features()
  local map = require("mini.map")
  local options = {
    integrations = {
      map.gen_integration.gitsigns(),
    },
    window = {
      width = 11,
      winblend = 25,
      show_integration_count = false
    },
    symbols = {
      scroll_line = "┃",
      scroll_view = "┃",
      encode = map.gen_encode_symbols.dot("4x2")
    }
  }

  map.setup(options)
  map.open(options)
end

local minimal = true
local function toggle()
  if minimal then
    setup_with_features()
    minimal = false
  else
    setup_minimal()
    minimal = true
  end
end

Lazy.use {
  "nvim-mini/mini.map",
  event = "VeryLazy",
  config = function()
    setup_minimal()
    -- vim.keymap.set("n", "<leader>X", toggle, { desc = "MiniMap Toggle" })
    vim.api.nvim_create_user_command("MiniMapToggle", toggle, { desc = "MiniMap Toggle" })
  end
}
