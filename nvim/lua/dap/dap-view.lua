--- @brief
--- nvim-dap-view integration: DAP UI Panel

local Lazy = require("core/lazy")

--- @type dapview.Config
local options = {
  auto_toggle = true,
  follow_tab = true,
  windows = {
    position = "below",
  },
  winbar = {
    default_section = "scopes",
    controls = {
      enabled = true
    }
  },
  virtual_text = {
    enabled = true,
    position = "eol"
  }
}

Lazy.use {
  "igorlfs/nvim-dap-view",
  opts = options
}
