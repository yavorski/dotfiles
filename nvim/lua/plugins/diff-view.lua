local Lazy = require("core/lazy")

--- @module "diffview"
--- @type DiffviewConfig
--- @diagnostic disable-next-line: missing-fields
local options = {
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    }
  }
}

Lazy.use {
  "sindrets/diffview.nvim",
  cmd = "DiffviewOpen",
  opts = options
}
