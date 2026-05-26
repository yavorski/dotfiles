local system = require("core/system")

local Lazy = require("core/lazy")
local colors = require("colors/colors")
local editor = require("colors/editor")
local syntax = require("colors/syntax")

--- @module "catppuccin"
--- @type CatppuccinOptions
local options = {
  kitty = false,
  flavour = "mocha",
  term_colors = true,
  transparent_background = false,
  background = {
    dark = "mocha",
    light = "mocha"
  },
  color_overrides = {
    mocha = colors
  },
  highlight_overrides = {
    mocha = function()
      return vim.tbl_extend("error", editor, syntax)
    end
  },
  auto_integrations = false,
  default_integrations = false,
  integrations = {
    fzf = true,
    gitsigns = true,
    nvimtree = true,
    which_key = true,
    lsp_trouble = true,
    treesitter_context = true,
    mini = { enabled = true },
    blink_cmp = { enabled = true, style = "bordered" },
  },
}

Lazy.use {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1024,
  build = ":CatppuccinCompile",
  config = function()
    require("catppuccin").setup(options)
    vim.cmd[[colorscheme catppuccin-nvim]]
  end
}
