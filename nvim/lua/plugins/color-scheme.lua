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
  integrations = {
    fzf = true,
    noice = true,
    nvimtree = true,
    diffview = true,
    blink_cmp = true,
    which_key = true,
    lsp_trouble = true,
    copilot_vim = true,
    semantic_tokens = true,
    mini = { enabled = true },
    native_lsp = { enabled = true },
  },
  color_overrides = {
    mocha = colors
  },
  highlight_overrides = {
    mocha = function()
      return vim.tbl_extend("error", editor, syntax)
    end
  }
}

Lazy.use {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1024,
  version = "1.11.0",
  build = ":CatppuccinCompile",
  config = function()
    require("catppuccin").setup(options)
    vim.cmd("colorscheme catppuccin-mocha")
  end
}
