--- @brief Constants for the ui2 wrapper modules.

local M = {}

--- Minimum width for the top-right "mini" msg float.
M.MSG_MIN_WIDTH = 42

--- Promote msg → pager when content exceeds these thresholds.
M.PAGER_MAX_LINES = 24
M.PAGER_WIDTH_RATIO = 0.75

--- Kinds dropped unconditionally before any other filter.
M.IGNORED_KINDS = {
  empty = true,
  bufwrite = true,
}

--- Lua patterns matched against the full message text.
M.SKIP_PATTERNS = {
  "%d+L, %d+B",       -- ":w" file written summary
  "; after #%d+",     -- undo/redo trailing change id (after)
  "; before #%d+",    -- undo/redo trailing change id (before)
  "%d+ fewer lines",  -- delete summary (any size)
  "%d+ more lines",   -- undo/redo summary (any size)
  "roslyn:.*%-32000", -- roslyn LSP shutdown chatter
}

--- Plain substring matches.
M.SKIP_SUBSTRINGS = {
  "An item with the same key has already been added",
}

--- Predicate filters: return true to drop the message.
M.SKIP_FUNCS = {
  -- Hide "N lines yanked" for small yanks; surface for >= 3 lines (noice-style).
  function(text)
    local n = text:match("^(%d+) lines yanked")
    return n ~= nil and tonumber(n) < 3
  end,
}

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
}

--- ui2.enable target map: kind -> sink window.
M.MSG_TARGETS = {
  [""] = "msg",
  empty = "msg",
  bufwrite = "msg",
  echo = "msg",
  echomsg = "msg",
  undo = "msg",
  wmsg = "msg",
  completion = "msg",
  -- `confirm`/`confirm_sub` are auto-routed to the internal dialog
  -- window when a prompt is active; this is just the fallback target.
  confirm = "msg",
  confirm_sub = "msg",
  echoerr = "msg",
  emsg = "msg",
  list_cmd = "pager",
  lua_error = "msg",
  lua_print = "msg",
  progress = "msg",
  quickfix = "msg",
  rpc_error = "msg",
  search_cmd = "msg",
  search_count = "msg", -- intercepted in msg_show -> virtual text
  shell_cmd = "msg",
  shell_err = "msg",
  shell_out = "pager",
  typed_cmd = "msg",
  verbose = "pager",
  wildlist = "msg",
}

return M
