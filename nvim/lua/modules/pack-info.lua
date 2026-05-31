------------------------------------------------------------
-- pack-info.lua
------------------------------------------------------------
-- Read-only floating window showing the current zpack / vim.pack state.
--
-- Sources:
--   * require("zpack").get_plugins() -- session status (loaded/pending/lazy/...)
--   * vim.pack.get(nil, { info = false }) -- git rev + filesystem path
--
-- Commands:
--   :PackInfo  open the window
--
-- Keymaps (inside the window):
--   ]] - next plugin
--   [[ - prev plugin
--   <q> / <Esc> - close
------------------------------------------------------------

local M = {}

------------------------------------------------------------
-- window sizing
------------------------------------------------------------
-- Final size is clamped to [MIN, MAX] and scaled to RATIO of the screen.

local WIDTH_MIN   = 120
local WIDTH_MAX   = 160
local WIDTH_RATIO = 0.9

local HEIGHT_MIN   = 20
local HEIGHT_MAX   = 40
local HEIGHT_RATIO = 0.85

local ns = vim.api.nvim_create_namespace("pack_info_ui")

local state = {
  bufnr      = nil,
  winid      = nil,
  autocmd    = nil,
  plugin_rows = {}, -- 1-based line numbers of plugin name rows
}

------------------------------------------------------------
-- highlights
------------------------------------------------------------

local function setup_highlights()
  local links = {
    PackInfoTitle    = "Title",
    PackInfoSection  = "Label",
    PackInfoLoaded   = "DiagnosticOk",
    PackInfoPending  = "DiagnosticWarn",
    PackInfoLazy     = "DiagnosticHint",
    PackInfoDisabled = "DiagnosticError",
    PackInfoInstall  = "DiagnosticInfo",
    PackInfoMuted    = "Comment",
    PackInfoHash     = "Number",
    PackInfoTrigger  = "Comment",
    PackInfoTrigKind = "Identifier",
  }
  for group, link in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = link, default = true })
  end
end

------------------------------------------------------------
-- helpers
------------------------------------------------------------

local function valid_window()
  return state.winid and vim.api.nvim_win_is_valid(state.winid)
end

local function valid_buffer()
  return state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr)
end

local function short_rev(rev)
  if not rev or rev == "" then return "        " end
  return rev:sub(1, 8)
end

local function sort_by_name(items)
  table.sort(items, function(a, b) return a.name < b.name end)
end

------------------------------------------------------------
-- trigger extraction (internal zpack state)
------------------------------------------------------------
-- zpack.api does not expose lazy triggers;
-- we read them from require("zpack.state").spec_registry.

--- Coerce one trigger value into an array of display strings.
--- Handles: string, string[], EventSpec, KeySpec, mixed arrays.
local function flatten_trigger(value)
  if value == nil then return {} end
  if type(value) == "string" then return { value } end
  if type(value) == "function" then return { "<fn>" } end
  if type(value) ~= "table" then return { tostring(value) } end

  -- EventSpec: { event = "...", pattern = "..." }
  if value.event and not value[1] then
    local ev = value.event
    if type(ev) == "string" then return { ev } end
    if type(ev) == "table" then
      local out = {}
      for _, e in ipairs(ev) do out[#out + 1] = tostring(e) end
      return out
    end
  end

  -- KeySpec (array-like with [1] = lhs)
  if type(value[1]) == "string" and value.mode == nil
    and value.event == nil and #value <= 2 and not value[3] then
    -- Single key spec: { "<leader>ff", function() ... end }
    return { value[1] }
  end

  -- Array of strings / EventSpecs / KeySpecs
  local out = {}
  for _, item in ipairs(value) do
    if type(item) == "string" then
      out[#out + 1] = item
    elseif type(item) == "table" then
      if item.event then
        local ev = item.event
        if type(ev) == "string" then
          out[#out + 1] = ev
        elseif type(ev) == "table" then
          for _, e in ipairs(ev) do out[#out + 1] = tostring(e) end
        end
      elseif type(item[1]) == "string" then
        out[#out + 1] = item[1] -- KeySpec lhs
      end
    end
  end
  return out
end

--- Resolve a possibly-function spec field by calling zpack's own helper
--- so behaviour matches the loader; falls back to raw value on error.
local function resolve_field(value, plugin, src, field_name)
  if type(value) ~= "function" then return value end
  local ok, utils = pcall(require, "zpack.utils")
  if ok and type(utils.try_resolve_field) == "function" then
    local ok2, resolved = pcall(utils.try_resolve_field, value, plugin, src, field_name)
    if ok2 then return resolved end
  end
  local ok3, resolved = pcall(value, plugin)
  if ok3 then return resolved end
  return nil
end

--- Return { event = {...}, cmd = {...}, ft = {...}, keys = {...} }
--- or nil if no triggers / internal state unavailable.
local function get_triggers_for(name)
  local ok, zstate = pcall(require, "zpack.state")
  if not ok or type(zstate) ~= "table" then return nil end

  local src = zstate.name_to_src and zstate.name_to_src[name]
  if not src then return nil end

  local entry = zstate.spec_registry and zstate.spec_registry[src]
  if not entry or not entry.merged_spec then return nil end

  local spec   = entry.merged_spec
  local plugin = entry.plugin

  local triggers = {}
  local function fill(field)
    local raw = resolve_field(spec[field], plugin, src, field)
    local list = flatten_trigger(raw)
    if #list > 0 then triggers[field] = list end
  end

  fill("event")
  fill("cmd")
  fill("ft")
  fill("keys")

  if next(triggers) == nil then return nil end
  return triggers
end

------------------------------------------------------------
-- data collection
------------------------------------------------------------

--- Collect everything we want to show, merging zpack.api info with
--- vim.pack git info (rev/path).
--- @return table<string, table> by_name
--- @return table groups
--- @return table totals
local function collect()
  local by_name = {}

  -- zpack snapshot (status, lazy, src, path)
  local ok_zpack, zpack = pcall(require, "zpack")
  if ok_zpack and type(zpack.get_plugins) == "function" then
    for _, p in ipairs(zpack.get_plugins()) do
      by_name[p.name] = {
        name   = p.name,
        src    = p.src,
        status = p.status, -- loaded | loading | pending | disabled | installing
        lazy   = p.lazy,
        path   = p.path,
        rev    = nil,
      }
    end
  end

  -- vim.pack data (rev, active, path) -- offline, no network
  local ok_pack, plugins = pcall(vim.pack.get, nil, { info = false })
  if ok_pack and type(plugins) == "table" then
    for _, plugin in ipairs(plugins) do
      local name = plugin.spec and plugin.spec.name
      if name then
        local entry = by_name[name]
        if not entry then
          entry = {
            name   = name,
            src    = plugin.spec.src,
            status = plugin.active and "loaded" or "pending",
            lazy   = false,
            path   = plugin.path,
          }
          by_name[name] = entry
        end
        entry.rev    = plugin.rev
        entry.path   = entry.path or plugin.path
        entry.active = plugin.active
      end
    end
  end

  -- Bucket by display group.
  local groups = {
    loaded     = {},
    pending    = {},
    lazy       = {},
    disabled   = {},
    installing = {},
  }

  for _, p in pairs(by_name) do
    if p.status == "loaded" or p.status == "loading" then
      table.insert(groups.loaded, p)
    elseif p.status == "installing" then
      table.insert(groups.installing, p)
    elseif p.status == "disabled" then
      table.insert(groups.disabled, p)
    elseif p.lazy then
      -- lazy + pending -> "lazy" bucket so it's clear they're awaiting trigger
      table.insert(groups.lazy, p)
    else
      table.insert(groups.pending, p)
    end
  end

  for _, list in pairs(groups) do sort_by_name(list) end

  -- Attach triggers to every plugin (best-effort; nil if unavailable).
  for _, p in pairs(by_name) do
    p.triggers = get_triggers_for(p.name)
  end

  local totals = {
    all        = vim.tbl_count(by_name),
    loaded     = #groups.loaded,
    pending    = #groups.pending,
    lazy       = #groups.lazy,
    disabled   = #groups.disabled,
    installing = #groups.installing,
  }

  return by_name, groups, totals
end

------------------------------------------------------------
-- rendering
------------------------------------------------------------

local function build_content(win_width)
  local _, groups, totals = collect()

  local lines, hls = {}, {}
  local plugin_rows = {} -- 1-based line numbers of plugin name rows

  local function center(text)
    local pad = math.max(0, math.floor((win_width - vim.fn.strdisplaywidth(text)) / 2))
    return string.rep(" ", pad) .. text
  end

  local function add(text, hl)
    local row = #lines
    lines[#lines + 1] = text or ""
    if hl and text and text ~= "" then
      hls[#hls + 1] = { row, 0, #text, hl }
    end
    return row
  end

  local function add_centered(text, hl)
    local row = #lines
    local padded = center(text)
    lines[#lines + 1] = padded
    if hl then
      local start_col = #padded - #text
      hls[#hls + 1] = { row, start_col, #padded, hl }
    end
    return row
  end

  local function add_hl(row, start_col, end_col, hl)
    hls[#hls + 1] = { row, start_col, end_col, hl }
  end

  -- header
  local zpack_version = "?"
  local ok_zpack, zpack = pcall(require, "zpack")
  if ok_zpack and zpack.VERSION then
    zpack_version = tostring(zpack.VERSION)
  end

  local header = ("zpack / vim.pack    %d plugins    api v%s"):format(
    totals.all,
    zpack_version
  )
  add("")
  add_centered(header, "PackInfoTitle")

  local summary = ("loaded %d   lazy %d   pending %d   disabled %d   installing %d"):format(
    totals.loaded,
    totals.lazy,
    totals.pending,
    totals.disabled,
    totals.installing
  )
  add_centered(summary, "PackInfoMuted")

  add("")

  -- width: longest plugin name across all groups
  local max_name = 0
  for _, list in pairs(groups) do
    for _, p in ipairs(list) do
      if #p.name > max_name then max_name = #p.name end
    end
  end
  if max_name < 12 then max_name = 12 end

  local function add_plugin(p, name_hl)
    local pad = string.rep(" ", math.max(0, max_name - #p.name))
    local rev = short_rev(p.rev)
    local lazy_tag = p.lazy and "  lazy" or ""
    local line = ("  %s%s  %s%s"):format(p.name, pad, rev, lazy_tag)

    local row = add(line)
    plugin_rows[#plugin_rows + 1] = row + 1 -- convert to 1-based

    -- name
    add_hl(row, 2, 2 + #p.name, name_hl)
    -- short rev
    local rev_start = 2 + #p.name + 2 + #pad
    if p.rev and p.rev ~= "" then
      add_hl(row, rev_start, rev_start + #rev, "PackInfoHash")
    else
      add_hl(row, rev_start, rev_start + #rev, "PackInfoMuted")
    end
    -- lazy tag
    if p.lazy then
      local tag_start = rev_start + #rev + 2
      add_hl(row, tag_start, tag_start + 4, "PackInfoLazy")
    end

    -- Trigger rows (lazy plugins only).
    if p.triggers then
      local order = { "event", "cmd", "ft", "keys" }
      for _, kind in ipairs(order) do
        local values = p.triggers[kind]
        if values and #values > 0 then
          local kind_label = kind .. ":"
          local trig_line  = ("      %s %s"):format(kind_label, table.concat(values, ", "))
          local trig_row   = add(trig_line, "PackInfoTrigger")
          -- highlight the "event:" / "cmd:" / etc. label
          add_hl(trig_row, 6, 6 + #kind_label, "PackInfoTrigKind")
        end
      end
    end
  end

  local function add_section(title, list, name_hl, empty_msg)
    add((" %s (%d)"):format(title, #list), "PackInfoSection")
    if #list == 0 then
      add("  " .. empty_msg, "PackInfoMuted")
    else
      for _, p in ipairs(list) do
        add_plugin(p, name_hl)
      end
    end
    add("")
  end

  add_section("Loaded",     groups.loaded,     "PackInfoLoaded",   "no loaded plugins")
  add_section("Lazy",       groups.lazy,       "PackInfoLazy",     "no lazy plugins awaiting trigger")
  add_section("Pending",    groups.pending,    "PackInfoPending",  "no pending plugins")
  add_section("Installing", groups.installing, "PackInfoInstall",  "no installs in progress")
  add_section("Disabled",   groups.disabled,   "PackInfoDisabled", "no disabled plugins")

  return lines, hls, plugin_rows
end

local function set_lines(lines, hls)
  if not valid_buffer() then return end

  vim.bo[state.bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
  vim.bo[state.bufnr].modifiable = false
  vim.bo[state.bufnr].modified = false

  vim.api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
  for _, hl in ipairs(hls) do
    vim.api.nvim_buf_set_extmark(state.bufnr, ns, hl[1], hl[2], {
      end_col = hl[3],
      hl_group = hl[4],
    })
  end
end

local function render()
  if not valid_buffer() or not valid_window() then return end
  local width = vim.api.nvim_win_get_width(state.winid)
  local lines, hls, plugin_rows = build_content(width)
  state.plugin_rows = plugin_rows
  set_lines(lines, hls)
end

------------------------------------------------------------
-- window lifecycle
------------------------------------------------------------

local function close()
  if state.autocmd then
    pcall(vim.api.nvim_del_autocmd, state.autocmd)
    state.autocmd = nil
  end
  if valid_window() then
    vim.api.nvim_win_close(state.winid, true)
  end
  state.winid = nil
  state.bufnr = nil
end

local function setup_keymaps()
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
      buffer  = state.bufnr,
      silent  = true,
      nowait  = true,
      desc    = desc,
    })
  end

  map("q",     close, "Close pack-info")
  map("<Esc>", close, "Close pack-info")
  map("<C-q>", close, "Close pack-info")

  -- jump to next plugin entry
  map("]]", function()
    local rows = state.plugin_rows
    if not rows or #rows == 0 then return end
    local cur = vim.api.nvim_win_get_cursor(state.winid)[1]
    local count = vim.v.count1
    local target
    for _, row in ipairs(rows) do
      if row > cur then
        count = count - 1
        if count == 0 then
          target = row
          break
        end
        cur = row
      end
    end
    if not target then target = rows[#rows] end
    vim.api.nvim_win_set_cursor(state.winid, { target, 0 })
  end, "Next plugin")

  -- jump to previous plugin entry
  map("[[", function()
    local rows = state.plugin_rows
    if not rows or #rows == 0 then return end
    local cur = vim.api.nvim_win_get_cursor(state.winid)[1]
    local count = vim.v.count1
    local target
    for i = #rows, 1, -1 do
      if rows[i] < cur then
        count = count - 1
        if count == 0 then
          target = rows[i]
          break
        end
        cur = rows[i]
      end
    end
    if not target then target = rows[1] end
    vim.api.nvim_win_set_cursor(state.winid, { target, 0 })
  end, "Prev plugin")
end

function M.open()
  if valid_window() then
    vim.api.nvim_set_current_win(state.winid)
    return
  end

  setup_highlights()

  state.bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[state.bufnr].buftype   = "nofile"
  vim.bo[state.bufnr].bufhidden = "wipe"
  vim.bo[state.bufnr].swapfile  = false
  vim.bo[state.bufnr].filetype  = "pack-info"

  local columns      = vim.o.columns
  local screen_lines = vim.o.lines
  local width  = math.min(WIDTH_MAX,  math.max(WIDTH_MIN,  math.floor(columns      * WIDTH_RATIO)))
  local height = math.min(HEIGHT_MAX, math.max(HEIGHT_MIN, math.floor(screen_lines * HEIGHT_RATIO)))

  state.winid = vim.api.nvim_open_win(state.bufnr, true, {
    relative  = "editor",
    width     = width,
    height    = height,
    row       = math.floor((screen_lines - height) / 2),
    col       = math.floor((columns - width) / 2),
    style     = "minimal",
    border    = require("core/border"),
    title     = " pack info ",
    title_pos = "center",
  })

  vim.wo[state.winid].cursorline = true
  vim.wo[state.winid].wrap       = false

  setup_keymaps()
  render()

  local captured_win = state.winid
  state.autocmd = vim.api.nvim_create_autocmd("WinClosed", {
    once = true,
    callback = function(ev)
      if tonumber(ev.match) == captured_win then
        state.autocmd = nil
        state.winid   = nil
        state.bufnr   = nil
      end
    end,
  })
end

------------------------------------------------------------
-- user command
------------------------------------------------------------

vim.api.nvim_create_user_command("PackInfo", function() M.open() end, { desc = "Show zpack / vim.pack plugin state" })

return M
