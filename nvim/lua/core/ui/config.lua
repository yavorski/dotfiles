--- @brief
--- Constants for the ui2 wrapper modules.

local M = {}

--- Min width of the mini msg float.
M.MSG_MIN_WIDTH = 42

--- msg→pager promotion thresholds.
M.PAGER_MAX_LINES = 24
M.PAGER_WIDTH_RATIO = 0.75

--- Kinds always dropped.
M.IGNORED_KINDS = {
  empty = true,
  bufwrite = true,
}

-- stylua: ignore
--- Drop when the full text matches.
M.SKIP_PATTERNS = {
  "%d+L, %d+B",       -- ":w" file written summary
  "; after #%d+",     -- undo/redo trailing change id (after)
  "; before #%d+",    -- undo/redo trailing change id (before)
  "%d+ fewer lines",  -- delete summary (any size)
  "%d+ more lines",   -- undo/redo summary (any size)
  "roslyn:.*%-32000", -- roslyn LSP shutdown chatter
}

--- Drop on substring.
M.SKIP_SUBSTRINGS = {
  "An item with the same key has already been added",
}

--- Drop when fn(text) is true.
M.SKIP_FUNCS = {
  -- Hide yanks under 3 lines (all register.c shapes).
  function(text)
    local n = text:match("^(%d+) lines? yanked") or text:match("^block of (%d+) lines? yanked")
    return n ~= nil and tonumber(n) < 3
  end,
}

-- stylua: ignore
--- @type table<string, [string, string]>  kind -> { title, highlight }
M.KIND_TITLES = {
  emsg         = { "Error",    "ErrorMsg" },
  echoerr      = { "Error",    "ErrorMsg" },
  lua_error    = { "Error",    "ErrorMsg" },
  rpc_error    = { "Error",    "ErrorMsg" },
  wmsg         = { "Warning",  "WarningMsg" },
  echo         = { "Info",     "Normal" },
  echomsg      = { "Info",     "Normal" },
  lua_print    = { "Print",    "Normal" },
  search_cmd   = { "Search",   "Normal" },
  search_count = { "Search",   "Normal" },
  undo         = { "Undo",     "Normal" },
  shell_out    = { "Shell",    "Normal" },
  shell_err    = { "Shell",    "ErrorMsg" },
  shell_cmd    = { "Shell",    "Normal" },
  quickfix     = { "Quickfix", "Normal" },
  progress     = { "Progress", "Normal" },
  typed_cmd    = { "Command",  "Normal" },
  list_cmd     = { "List",     "Normal" },
  verbose      = { "Verbose",  "Comment" },
  confirm      = { "Confirm",  "Question" },
  confirm_sub  = { "Confirm",  "Question" },
  completion   = { "Completion", "Normal" },
  wildlist     = { "Wildmenu", "Normal" },
}

--- kind -> sink window.
M.MSG_TARGETS = {
  -- default: fallback for unmapped kinds (old ui2 also needs cfg.msg.target, see init.lua).
  -- No "" / typed_cmd keys: triggers beat kinds and would hijack pager routes.
  default = "msg",
  empty = "msg",
  bufwrite = "msg",
  echo = "msg",
  echomsg = "msg",
  undo = "msg",
  wmsg = "msg",
  completion = "msg",
  -- fallback only; active prompts auto-route to dialog.
  confirm = "msg",
  confirm_sub = "msg",
  echoerr = "msg",
  emsg = "msg",
  -- :set? :ls :map :reg ...
  list_cmd = "pager",
  lua_error = "msg",
  lua_print = "msg",
  progress = "msg",
  quickfix = "msg",
  rpc_error = "msg",
  search_cmd = "msg",
  search_count = "msg", -- shown as virtual text
  shell_cmd = "msg",
  shell_err = "msg",
  shell_out = "pager",
  verbose = "pager",
  wildlist = "msg",
}

return M
