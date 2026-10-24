--- @brief
--- Shows key bindings in popup

local Lazy = require("core/lazy")

--- @module "which-key"
--- @type wk.Opts
local options = {
  --- @type wk.Win.opts
  win = {
    no_overlap = false,
  },

  --- @type false | "classic" | "modern" | "helix"
  preset = "modern",

  --- @type number | function
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,

  --- @type wk.Spec
  spec = {
    { "gs", group = "Git Signs" },
    { "gb", group = "Go to Buffer" },
    { "gx", desc = "System app open path or URL" },
    { "sj", mode = { "n", "x" }, desc = "Split/Join" },
    { "<c-w>c", desc = "Close current window" },
    { "<leader>\\", group = "NvimTree" },
    { "<leader>W", group = "LSP Workspace" },
    -- { "<leader>?", "<cmd>WhichKey<cr>", desc = "Which Key" },
  },

  --- @type wk.Spec
  triggers = {
    { "<auto>", mode = "nxso" },
    { "s", mode = { "n", "v", "x" } },
  },

  icons = {
    rules = false,
    mappings = false,
    keys = {
      BS = "⇠ ",
      Space = " 󱁐 ",
    },
  },

  plugins = {
    marks = true, -- shows marks on ' and `
    registers = true, -- shows registers on " and <C-r>
    spelling = {
      enabled = true, -- shows on z= with spelling suggestions
      suggestions = 20, -- how many suggestions to show
    },
    presets = {
      operators = true, -- operators like d, y, ...
      motions = true, -- motions like w, b, ...
      text_objects = true, -- text objects after an operator, like iw, a"
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc navigation bindings, like H, M, L
      z = true, -- z prefixed: folds, spelling and others
      g = true, -- g prefixed: gt, gf, gi, ...
    },
  },
}

Lazy.use {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = options,
}
