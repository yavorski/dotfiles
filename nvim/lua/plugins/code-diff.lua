--- @brief
--- A Neovim plugin that provides VSCode-style side-by-side diff rendering with two-tier highlighting.

--- neovim native diff
--- nvim -d file-a file-b
--- `]c` - go to next change
--- `[c` - go to prev change
--- `dp` - diffput to other file
--- `do` - diffget from other file

local Lazy = require("core/lazy")

local options = {
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
    layout = "side-by-side",             -- Diff layout: "side-by-side" (two panes) or "inline" (single pane with virtual lines)
    disable_inlay_hints = true,         -- Disable inlay hints in diff windows for cleaner view
    max_computation_time_ms = 5000,     -- Maximum time for diff computation (VSCode default)
    ignore_trim_whitespace = false,     -- Ignore leading/trailing whitespace changes (like diffopt+=iwhite)
    hide_merge_artifacts = false,       -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
    original_position = "left",         -- Position of original (old) content: "left" or "right"
    conflict_ours_position = "right",   -- Position of ours (:2) in conflict view: "left" or "right"
    conflict_result_position = "bottom", -- "bottom" (default): result below diff panes or "center": result between diff panes (three columns)
    conflict_result_height = 30,         -- Height of result pane in bottom layout (% of total height)
    conflict_result_width_ratio = { 1, 1, 1 }, -- Width ratio for center layout panes {left, center, right} (e.g., {1, 2, 1} for wider result)
    cycle_next_hunk = true,             -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
    cycle_next_file = true,             -- Wrap around when navigating files (]f/[f): false to stop at first/last
    jump_to_first_change = true,        -- Auto-scroll to first change when opening a diff: false to stay at same line
    highlight_priority = 100,           -- Priority for line-level diff highlights (increase to override LSP highlights)
    compute_moves = false,              -- Detect moved code blocks (opt-in, matches VSCode experimental.showMoves)
  },

  -- Explorer panel configuration
  explorer = {
    position = "left",            -- "left" or "bottom"
    width = 40,                   -- Width when position is "left" (columns)
    height = 15,                  -- Height when position is "bottom" (lines)
    indent_markers = true,        -- Show indent markers in tree view (│, ├, └)
    initial_focus = "explorer",   -- Initial focus: "explorer", "original", or "modified"
    icons = {
      folder_open = "",           -- Nerd Font folder-open icon
      folder_closed = "",         -- Nerd Font folder icon (customize as needed)
    },
    view_mode = "list",           -- "list" or "tree"
    flatten_dirs = true,          -- Flatten single-child directory chains in tree view
    file_filter = {
      ignore = {
        ".git/**",
        ".jj/**"
      },
    },
    focus_on_select = false,      -- Jump to modified pane after selecting a file (default: stay in explorer)
    visible_groups = {
      staged = true,
      unstaged = true,
      conflicts = true,
    },
  },

  -- History panel configuration (for :CodeDiff history)
  history = {
    position = "bottom",        -- "left" or "bottom" (default: bottom)
    width = 40,                 -- Width when position is "left" (columns)
    height = 15,                -- Height when position is "bottom" (lines)
    view_mode = "list",         -- "list" or "tree" for files under commits
    initial_focus = "history",  -- Initial focus: "history", "original", or "modified"
  },

  -- Keymaps in diff view
  keymaps = {
    view = {
      quit = "<C-q>",                   -- Close diff tab
      focus_explorer = "<leader>e",     -- Focus explorer panel (explorer mode only)
      toggle_explorer = [[<leader>\\]], -- Toggle explorer visibility (explorer mode only)

      next_hunk = "]c",   -- Jump to next change
      prev_hunk = "[c",   -- Jump to previous change
      next_file = "]f",   -- Next file in explorer/history mode
      prev_file = "[f",   -- Previous file in explorer/history mode
      diff_get = "do",    -- Get change from other buffer (like vimdiff)
      diff_put = "dp",    -- Put change to other buffer (like vimdiff)

      open_in_prev_tab = "gf", -- Open current buffer in previous tab (or create one before)
      close_on_open_in_prev_tab = false, -- Close codediff tab after gf opens file in previous tab

      toggle_stage = "-",           -- Stage/unstage current file (works in explorer and diff buffers)
      stage_hunk = "<leader>hs",    -- Stage hunk under cursor to git index
      unstage_hunk = "<leader>hu",  -- Unstage hunk under cursor from git index
      discard_hunk = "<leader>hr",  -- Discard hunk under cursor (working tree only)
      hunk_textobject = "ih",       -- Textobject for hunk (vih to select, yih to yank, etc.)
      show_help = "g?",             -- Show floating window with available keymaps
      align_move = "gm",            -- Temporarily align moved code blocks across panes
      toggle_layout = "t",          -- Toggle between side-by-side and inline layout
    },
    explorer = {
      select = "<CR>",        -- Open diff for selected file
      hover = "K",            -- Show file diff preview
      refresh = "R",          -- Refresh git status
      stage_all = "S",        -- Stage all files
      unstage_all = "U",      -- Unstage all files
      restore = "X",          -- Discard changes (restore file)
      toggle_staged = "gs",   -- Toggle Staged Changes group visibility
      toggle_changes = "gu",  -- Toggle Changes (unstaged) group visibility
      toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views

      -- Fold keymaps (Vim-style)
      fold_open = "zo",             -- Open fold (expand current node)
      fold_open_recursive = "zO",   -- Open fold recursively (expand all descendants)
      fold_close = "zc",            -- Close fold (collapse current node)
      fold_close_recursive = "zC",  -- Close fold recursively (collapse all descendants)
      fold_toggle = "za",           -- Toggle fold (expand/collapse current node)
      fold_toggle_recursive = "zA", -- Toggle fold recursively
      fold_open_all = "zR",         -- Open all folds in tree
      fold_close_all = "zM",        -- Close all folds in tree
    },
    history = {
      select = "<CR>",        -- Select commit/file or toggle expand
      refresh = "R",          -- Refresh history (re-fetch commits)
      toggle_view_mode = "i", -- Toggle between 'list' and 'tree' views

      -- Fold keymaps (Vim-style, apply to directory nodes only)
      fold_open = "zo",             -- Open fold (expand current node)
      fold_open_recursive = "zO",   -- Open fold recursively (expand all descendants)
      fold_close = "zc",            -- Close fold (collapse current node)
      fold_close_recursive = "zC",  -- Close fold recursively (collapse all descendants)
      fold_toggle = "za",           -- Toggle fold (expand/collapse current node)
      fold_toggle_recursive = "zA", -- Toggle fold recursively
      fold_open_all = "zR",         -- Open all folds in tree
      fold_close_all = "zM",        -- Close all folds in tree
    },
    conflict = {
      accept_incoming = "<leader>ct",  -- Accept incoming (theirs/left) change
      accept_current = "<leader>co",   -- Accept current (ours/right) change
      accept_both = "<leader>cb",      -- Accept both changes (incoming first)
      discard = "<leader>cx",          -- Discard both, keep base

      -- Accept all (whole file) - uppercase versions
      accept_all_incoming = "<leader>cT", -- Accept ALL incoming changes
      accept_all_current = "<leader>cO",  -- Accept ALL current changes
      accept_all_both = "<leader>cB",     -- Accept ALL both changes
      discard_all = "<leader>cX",         -- Discard ALL, reset to base
      next_conflict = "]x",               -- Jump to next conflict
      prev_conflict = "[x",               -- Jump to previous conflict
      diffget_incoming = "2do",           -- Get hunk from incoming (left/theirs) buffer
      diffget_current = "3do",            -- Get hunk from current (right/ours) buffer
    }
  }
}

Lazy.use {
  src = "https://github.com/esmuellert/codediff.nvim",
  data = {
    lazy = true,
    cmd = { "CodeDiff" },
    after = function()
      require("codediff").setup(options)
    end
  }
}
