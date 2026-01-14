--- @brief
--- A Neovim plugin that provides VSCode-style side-by-side diff rendering with two-tier highlighting.

--- neovim native diff
--- nvim -d file-a file-b
--- `]c` - go to next change
--- `[c` - go to prev change
--- `dp` - diffput to other file
--- `do` - diffget from other file

local Lazy = require("core/lazy")

-- only diff viewer cannot merge
-- https://gh.com/esmuellert/vscode-diff.nvim/issues/34
Lazy.use {
  "esmuellert/codediff.nvim",
  -- dir = "~/dev/open-sos/vscode-diff.nvim",
  cmd = "CodeDiff",
  config = function()
    require("codediff").setup({
      -- Highlight configuration
      highlights = {
        line_insert = "DiffAdd",      -- Line-level insertions
        line_delete = "DiffDelete",   -- Line-level deletions
        char_insert = nil,            -- Character-level insertions (nil = auto-derive)
        char_delete = nil,            -- Character-level deletions (nil = auto-derive)
        char_brightness = nil,        -- Auto-adjust based on your colorscheme
        conflict_sign = nil,          -- Unresolved: DiagnosticSignWarn
        conflict_sign_resolved = nil, -- Resolved: Comment
        conflict_sign_accepted = nil, -- Accepted: GitSignsAdd -> DiagnosticSignOk
        conflict_sign_rejected = nil, -- Rejected: GitSignsDelete -> DiagnosticSignError
      },

      -- Diff view behavior
      diff = {
        disable_inlay_hints = true,         -- Disable inlay hints in diff windows
        max_computation_time_ms = 5000,     -- Maximum time for diff computation
        hide_merge_artifacts = false,       -- Hide merge tool temp files *.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*
        original_position = "left",         -- Position of original (old) content: "left" or "right"
        conflict_ours_position = "right",   -- Position of ours (:2) in conflict view: "left" or "right"
      },

      -- Explorer panel configuration
      explorer = {
        position = "left",
        width = 40,
        height = 15,
        indent_markers = true, -- Show indent markers in tree view
        icons = {
          folder_open = "",
          folder_closed = "",
        },
        view_mode = "list", -- "list" or "tree"
        file_filter = {
          ignore = {}, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
        },
      },

      -- Keymaps in diff view
      keymaps = {
        view = {
          quit = "<C-q>",                   -- Close diff tab
          next_hunk = "]c",                 -- Jump to next change
          prev_hunk = "[c",                 -- Jump to previous change
          next_file = "]f",                 -- Next file in explorer mode
          prev_file = "[f",                 -- Previous file in explorer mode
          diff_get = "do",                  -- Get change from other buffer (like vimdiff)
          diff_put = "dp",                  -- Put change to other buffer (like vimdiff)
          toggle_explorer = [[<leader>\\]], -- Toggle explorer visibility (explorer mode only)
        },
        explorer = {
          select = "<CR>",        -- Open diff for selected file
          hover = "K",            -- Show file diff preview
          refresh = "R",          -- Refresh git status
          stage_all = "S",        -- Stage all files
          unstage_all = "U",      -- Unstage all files
          restore = "X",          -- Discard changes (restore file)
          toggle_stage = "-",     -- Stage/unstage selected file
          toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views
        },
        conflict = {
          accept_incoming = "<leader>ct", -- Accept incoming (theirs/left) change
          accept_current = "<leader>co",  -- Accept current (ours/right) change
          accept_both = "<leader>cb",     -- Accept both changes (incoming first)
          discard = "<leader>cx",         -- Discard both, keep base
          next_conflict = "]x",           -- Jump to next conflict
          prev_conflict = "[x",           -- Jump to previous conflict
          diffget_incoming = "2do",       -- Get hunk from incoming (left/theirs) buffer
          diffget_current = "3do",        -- Get hunk from current (right/ours) buffer
        },
      },
    })
  end
}
