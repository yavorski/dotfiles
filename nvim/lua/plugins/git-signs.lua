local Lazy = require("core/lazy")

--- @param direction string: "first"|"last"|"next"|"prev"
local function navigate(direction)
  return function()
    require("gitsigns").nav_hunk(direction)
  end
end

--- @module "gitsigns"
--- @type Gitsigns.Config
--- @diagnostic disable: missing-fields
local options = {
  trouble = false,
  diff_opts = {
    indent_heuristic = true
  },
  on_attach = function(buffer)
    local gs = require("gitsigns")

    vim.keymap.set("n", "[G", navigate("first"), { buffer = buffer, silent = true, desc = "First Hunk" })
    vim.keymap.set("n", "]G", navigate("last"), { buffer = buffer, silent = true, desc = "Last Hunk" })

    vim.keymap.set("n", "[g", navigate("prev"), { buffer = buffer, silent = true, desc = "Prev Hunk" })
    vim.keymap.set("n", "]g", navigate("next"), { buffer = buffer, silent = true, desc = "Next Hunk" })

    vim.keymap.set("n", "gsp", navigate("prev"), { buffer = buffer, silent = true, desc = "Prev Hunk" })
    vim.keymap.set("n", "gsn", navigate("next"), { buffer = buffer, silent = true, desc = "Next Hunk" })

    vim.keymap.set("n", "gss", gs.stage_hunk, { buffer = buffer, silent = true, desc = "Stage Hunk" })
    vim.keymap.set("n", "gsa", gs.stage_hunk, { buffer = buffer, silent = true, desc = "Stage Hunk" })

    vim.keymap.set("n", "gsr", gs.reset_hunk, { buffer = buffer, silent = true, desc = "Reset Hunk" })
    vim.keymap.set("n", "gsR", gs.reset_buffer, { buffer = buffer, silent = true, desc = "Reset Buffer" })

    vim.keymap.set("n", "gsv", gs.preview_hunk, { buffer = buffer, silent = true, desc = "Preview Hunk" })

    vim.keymap.set("n", "gsb", gs.blame_line, { buffer = buffer, silent = true, desc = "Blame Line" })
    vim.keymap.set("n", "gsB", function() gs.blame_line({ full = true }) end, { buffer = buffer, silent = true, desc = "Blame Line Full" })
  end
}

Lazy.use {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufReadPost" },
  opts = options
}
