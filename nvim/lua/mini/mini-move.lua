--- @brief
--- Move any selection in any direction - [n,v,x] <Alt+hjkl>

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.move",
  opts = { },
  keys = {
    { "<A-k>", function() require("mini.move").move_line("up") end, mode = "n", desc = "Move line up" },
    { "<A-j>", function() require("mini.move").move_line("down") end, mode = "n", desc = "Move line down" },
    { "<A-h>", function() require("mini.move").move_line("left") end, mode = "n", desc = "Move line left" },
    { "<A-l>", function() require("mini.move").move_line("right") end, mode = "n", desc = "Move line right" },

    { "<A-k>", function() require("mini.move").move_selection("up") end, mode = "x", desc = "Move selection up" },
    { "<A-j>", function() require("mini.move").move_selection("down") end, mode = "x", desc = "Move selection down" },
    { "<A-h>", function() require("mini.move").move_selection("left") end, mode = "x", desc = "Move selection left" },
    { "<A-l>", function() require("mini.move").move_selection("right") end, mode = "x", desc = "Move selection right" },

    { "<", function() require("mini.move").move_line("left") end, mode = "n", desc = "Move line left" },
    { ">", function() require("mini.move").move_line("right") end, mode = "n", desc = "Move line right" },
    { "<", function() require("mini.move").move_selection("left") end, mode = "x", desc = "Move selection left" },
    { ">", function() require("mini.move").move_selection("right") end, mode = "x", desc = "Move selection right" },
  }
}
