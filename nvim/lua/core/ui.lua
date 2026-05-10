--- @brief
--- https://neovim.io/doc/user/lua/#_ui2
--- * Ephemeral, top-right "mini" message float notification view.
--- * Pager popup for large messages, `:messages`, `:history` and verbose output.
--- * Filters noisy write summary lines, undo/redo headers, and `bufwrite` events.
--- * Surfaces large yanks (>= 3 lines) as a notification.
--- * Kind-aware titles and highlights on message floats.
--- * LSP progress routed through `nvim_echo` with `kind = "progress"`.
--- * Cmdline is left to `tiny-cmdline` (see plugins/cmd-line.lua).
--- * `g<` enters the pager.

local ui2 = require "vim._core.ui2"
local msgs = require "vim._core.ui2.messages"
local border = require "core/border"

--- Kinds dropped unconditionally before any other filter.
local IGNORED_KINDS = {
  empty = true,
  bufwrite = true,
}

--- Lua patterns matched against the full message text.
local SKIP_PATTERNS = {
  "%d+L, %d+B",       -- ":w" file written summary
  "; after #%d+",     -- undo/redo trailing change id (after)
  "; before #%d+",    -- undo/redo trailing change id (before)
  "%d+ fewer lines",  -- delete summary (any size)
  "%d+ more lines",   -- undo/redo summary (any size)
  "roslyn:.*%-32000", -- roslyn LSP shutdown chatter
}

--- Plain substring matches.
local SKIP_SUBSTRINGS = {
  "An item with the same key has already been added",
}

--- Predicate filters: return true to drop the message.
local SKIP_FUNCS = {
  -- Hide "N lines yanked" for small yanks; surface for >= 3 lines (noice-style).
  function(text)
    local n = text:match("^(%d+) lines yanked")
    return n ~= nil and tonumber(n) < 3
  end
}

--- @type table<string, [string, string]>  kind -> { title, highlight }
local KIND_TITLES = {
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

--- Promote msg → pager when content exceeds these thresholds.
local PAGER_WIDTH_RATIO = 0.75
local PAGER_MAX_LINES = 24

--- Minimum width for the top-right "mini" msg float.
local MSG_MIN_WIDTH = 42

--- State

--- @class TitleEntry
--- @field [1] string  title text
--- @field [2] string  highlight group

--- Per-target title state. Reset by `msg_clear`.
--- @type table<"msg"|"pager"|"dialog", TitleEntry?>
local titles = { msg = nil, pager = nil, dialog = nil }

--- Helpers

--- @param content table|string|nil
--- @return string
local function content_to_text(content)
  if type(content) ~= "table" then
    return tostring(content or "")
  end
  local parts = {}
  for _, chunk in ipairs(content) do
    if type(chunk) == "table" and chunk[2] then
      parts[#parts + 1] = chunk[2]
    end
  end
  return table.concat(parts)
end

--- @param kind string
--- @param content table
--- @return boolean
local function should_skip(kind, content)
  if IGNORED_KINDS[kind] then
    return true
  end
  local text = content_to_text(content)
  for _, pat in ipairs(SKIP_PATTERNS) do
    if text:find(pat) then return true end
  end
  for _, sub in ipairs(SKIP_SUBSTRINGS) do
    if text:find(sub, 1, true) then return true end
  end
  for _, fn in ipairs(SKIP_FUNCS) do
    if fn(text) then return true end
  end
  return false
end

--- @param kind string
--- @param content table
--- @return string title, string highlight
local function resolve_title(kind, content)
  local entry = KIND_TITLES[kind]
  if entry then
    return entry[1], entry[2]
  end
  local text = vim.trim(content_to_text(content)):gsub("\n.*", "")
  if #text > 40 then
    text = text:sub(1, 37) .. "…"
  end
  return text ~= "" and text or "Message", "Normal"
end

--- @param win integer?
--- @return integer? win  non-nil only when the window is valid
local function valid_win(win)
  if win == nil or win == -1 or not vim.api.nvim_win_is_valid(win) then
    return nil
  end
  return win
end

--- Build the `title` chunk passed to `nvim_win_set_config`, with symmetric
--- padding so `title_pos = "center"` looks centered.
--- @param entry TitleEntry?
--- @return table?
local function title_chunks(entry)
  if not entry then return nil end
  return { { " " .. vim.trim(entry[1]) .. " ", entry[2] } }
end

--- Window decorators

--- @param target "pager"|"dialog"
--- @param win integer?
local function decorate(target, win)
  win = valid_win(win)
  if not win then return end
  if vim.api.nvim_win_get_config(win).hide then return end
  local title = title_chunks(titles[target])
  vim.api.nvim_win_set_config(win, {
    border = border,
    title = title,
    title_pos = title and "center" or nil,
  })
end

--- Re-anchor the msg window as a top-right "mini notify" float.
--- @param win integer?
local function decorate_msg(win)
  win = valid_win(win)
  if not win then return end
  if vim.api.nvim_win_get_config(win).hide then return end
  local width = math.max(vim.api.nvim_win_get_width(win), MSG_MIN_WIDTH)
  local title = title_chunks(titles.msg)
  vim.api.nvim_win_set_config(win, {
    relative = "editor",
    anchor = "NE",
    row = 1,
    col = vim.o.columns - 3,
    width = width,
    border = border,
    title = title,
    title_pos = title and "center" or nil,
  })
end

local function decorate_all()
  if not ui2.wins then return end
  decorate_msg(ui2.wins.msg)
  decorate("pager", ui2.wins.pager)
  decorate("dialog", ui2.wins.dialog)
end

-- ui2 enable

ui2.enable({
  enable = true,
  msg = {
    targets = {
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
      search_count = "msg",
      shell_cmd = "msg",
      shell_err = "msg",
      shell_out = "pager",
      typed_cmd = "msg",
      verbose = "pager",
      wildlist = "msg",
    },
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 2800 },
    pager = { height = 0.8 },
  },
})

--- Wrap set_pos: re-apply decorations after upstream positioning

local orig_set_pos = msgs.set_pos

msgs.set_pos = function(target)
  orig_set_pos(target)
  if target == nil then
    decorate_all()
  elseif target == "msg" then
    decorate_msg(ui2.wins.msg)
  elseif target == "pager" then
    decorate("pager", ui2.wins.pager)
  elseif target == "dialog" then
    decorate("dialog", ui2.wins.dialog)
  end
end

--- Wrap msg_show: filter + title tracking, delegate to upstream

local orig_msg_show = msgs.msg_show

msgs.msg_show = function(kind, content, replace_last, history, append, id, trigger)
  if should_skip(kind, content) then
    return
  end

  -- Resolve the title for whichever sink upstream picks.
  -- We can't know the final target without duplicating upstream routing, so set all three; whichever window opens will display the right one.
  local title, hl = resolve_title(kind, content)
  local entry = { title, hl }
  titles.msg, titles.pager, titles.dialog = entry, entry, entry

  return orig_msg_show(kind, content, replace_last, history, append, id, trigger)
end

--- Wrap show_msg: auto-promote oversized msg-window content to pager

local orig_show_msg = msgs.show_msg

msgs.show_msg = function(target, kind, content, replace_last, append, id)
  if target == "msg" then
    local text = content_to_text(content)
    local lines = vim.split(text, "\n", { plain = true })
    local width = 0
    for _, line in ipairs(lines) do
      local w = vim.api.nvim_strwidth(line)
      if w > width then width = w end
    end
    if width > math.floor(vim.o.columns * PAGER_WIDTH_RATIO) or #lines > PAGER_MAX_LINES then
      orig_show_msg("pager", kind, content, replace_last, append, id)
      msgs.set_pos("pager")
      return
    end
  end
  return orig_show_msg(target, kind, content, replace_last, append, id)
end

--- Wrap msg_clear: reset per-target title state

local orig_msg_clear = msgs.msg_clear
if orig_msg_clear then
  msgs.msg_clear = function(...)
    titles.msg, titles.pager, titles.dialog = nil, nil, nil
    return orig_msg_clear(...)
  end
end

--- LSP progress

local augroup = vim.api.nvim_create_augroup("LspProgressMessages", { clear = true })

vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup,
  callback = function(ev)
    local value = ev.data and ev.data.params and ev.data.params.value
    if type(value) ~= "table" then return end
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    -- Skip empty "GitHub Copilot" progress heartbeats (matches noice route).
    if value.title == "GitHub Copilot" and not value.message then
      return
    end

    local is_end = value.kind == "end"
    local text = value.message
        and (client.name .. ": " .. value.message)
        or (client.name .. (is_end and ": done" or ""))

    vim.api.nvim_echo({ { text } }, false, {
      id = "lsp." .. ev.data.client_id,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = is_end and "success" or "running",
      percent = value.percentage,
    })
  end
})

--- Debug helper
_G.d = function(...)
  vim.notify(vim.inspect(...), vim.log.levels.DEBUG)
end
