--- @brief
--- Auto close/rename html tag

local Lazy = require("core/lazy")

Lazy.use {
  "windwp/nvim-ts-autotag",
  ft = {
    "html",
    "razor",
    "cshtml",
    "htmlangular"
  },
  opts = {
    aliases = {
      ["razor"] = "html",
      ["cshtml"] = "html"
    },
    --- @module "nvim-ts-autotag"
    --- @type nvim-ts-autotag.Opts
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true
    }
  }
}
