--- @brief
--- Shows key bindings in popup

local Lazy = require("core/lazy")

--- @module "which-key"
--- @type wk.Opts
local options = {
  --- @type wk.Win.opts
  win = { no_overlap = false },

  --- @type false | "classic" | "modern" | "helix"
  preset = "classic",

  --- @type number | function
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,

  ---@type wk.Spec
  spec = {
    { "gs", group = "Git Signs" },
    { "gm", group = "Go to Mark" },
    { "gb", group = "Go to Buffer" },
    { "sj", mode = { "n", "x" }, desc = "Split/Join" },
    { "<leader>c", group = "Copilot" },
    { "<leader>\\", group = "NvimTree" },
    { "<leader>W", group = "LSP Workspace" },
    { "<leader>?", "<cmd>WhichKey<cr>", desc = "Which Key" },
  },

  --- @type wk.Spec
  triggers = {
    { "<auto>", mode = "nxsot" },
    { "s", mode = { "n", "v", "x" } },
  },

  icons = {
    rules = false,
    mappings = false,
    keys = { BS = "⇠ " }
  },
}

Lazy.use {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = options
}
