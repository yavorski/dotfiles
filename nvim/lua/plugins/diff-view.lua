--- @brief
--- A Neovim plugin that provides VSCode-style side-by-side diff rendering with two-tier highlighting.

--- neovim native diff
--- nvim -d file-a file-b
--- `]c` - go to next change
--- `[c` - go to prev change
--- `dp` - diffput to other file
--- `do` - diffget from other file

local Lazy = require("core/lazy")

-- still used for merges
Lazy.use {
  "sindrets/diffview.nvim",
  cmd = "DiffviewOpen",
  opts = {
  enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      }
    }
  }
}

-- only diff viewer cannot merge
-- https://gh.com/esmuellert/vscode-diff.nvim/issues/34
Lazy.use {
  "esmuellert/vscode-diff.nvim",
  -- dir = "~/dev/open-sos/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  config = function()
    require("vscode-diff").setup({
      -- Highlight configuration
      highlights = {
        line_insert = "DiffAdd",    -- Line-level insertions
        line_delete = "DiffDelete", -- Line-level deletions

        -- Character-level: accepts highlight group names or hex colors
        -- If specified, these override char_brightness calculation
        char_insert = nil, -- Character-level insertions (nil = auto-derive)
        char_delete = nil, -- Character-level deletions (nil = auto-derive)

        -- Brightness multiplier (only used when char_insert/char_delete are nil)
        -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
        char_brightness = nil, -- Auto-adjust based on your colorscheme
      },

      -- Diff view behavior
      diff = {
        disable_inlay_hints = true,     -- Disable inlay hints in diff windows for cleaner view
        max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
      },

      -- Keymaps in diff view
      -- TODO: Fix keymaps to be only buffer local and valid only in diff-view
      keymaps = {
        view = {
          quit = "<C-q>",                   -- Close diff tab
          toggle_explorer = [[<leader>\\]], -- Toggle explorer visibility (explorer mode only)
          next_hunk = "]c",                 -- Jump to next change
          prev_hunk = "[c",                 -- Jump to previous change
          next_file = "]f",                 -- Next file in explorer mode
          prev_file = "[f",                 -- Previous file in explorer mode
        },
        explorer = {
          select = "<cr>", -- Open diff for selected file
          hover = "K",     -- Show file diff preview
          refresh = "R",   -- Refresh git status
        }
      }
    })
  end
}
