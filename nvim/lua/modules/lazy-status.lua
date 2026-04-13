--- @brief
--- @module "lazy-status"
--- Show plugin load status in a floating window

local MAX_WIDTH = 0.8   -- max width as a fraction of screen columns
local MAX_HEIGHT = 0.7  -- max height as a fraction of screen lines

local Lazy = require("core/lazy")

--- @param spec lz.n.PluginLoadSpec
--- @return string[]
local function get_triggers(spec)
  local triggers = {}

  if spec.cmd then
    local cmds = type(spec.cmd) == "string" and { spec.cmd } or spec.cmd
    table.insert(triggers, "CMD: " .. table.concat(cmds, ", "))
  end

  if spec.event then
    local evs = type(spec.event) == "string" and { spec.event } or spec.event
    -- lz.n converts `ft` into FileType events internally, detect and show as FileType:
    local all_ft = vim.tbl_filter(function(e) return type(e) == "table" and e.event == "FileType" end, evs)
    if #all_ft == #evs and #evs > 0 then
      local patterns = vim.tbl_map(function(e) return e.pattern end, all_ft)
      table.insert(triggers, "FileType: " .. table.concat(patterns, ", "))
    else
      local events = vim.tbl_map(function(e)
        if type(e) == "table" then
          return e.pattern and (e.event .. ":" .. e.pattern) or e.event or e[1]
        end
        return e
      end, evs)
      table.insert(triggers, "Event: " .. table.concat(events, ", "))
    end
  end

  if spec.ft then
    local fts = type(spec.ft) == "string" and { spec.ft } or spec.ft
    table.insert(triggers, "FileType: " .. table.concat(fts, ", "))
  end

  if spec.keys then
    local keys = vim.tbl_map(function(k) return type(k) == "table" and (k.lhs or k[1]) or k end, spec.keys)
    table.insert(triggers, "Keys: " .. table.concat(keys, ", "))
  end

  return triggers
end

--- @class LazyStatusEntry
--- @field name string
--- @field loaded boolean
--- @field lazy boolean
--- @field status string
--- @field triggers string[]

--- @return LazyStatusEntry[], number, number
local function get_entries()
  local rtp = vim.opt.rtp:get()
  local entries = {}
  local n_loaded, n_total = 0, 0

  for _, p in ipairs(vim.pack.get()) do
    local name = p.spec.name
    local loaded = vim.tbl_contains(rtp, p.path)
    local pending = require("lz.n").lookup(name)
    local spec = pending or Lazy._specs[name]

    n_total = n_total + 1
    if loaded then n_loaded = n_loaded + 1 end

    table.insert(entries, {
      name = name,
      loaded = loaded,
      -- if no spec, plugin was loaded eagerly without lz.n (e.g. lz.n itself)
      lazy = spec ~= nil and (spec.lazy ~= false),
      status = loaded and "Loaded" or "Not Loaded",
      triggers = spec and get_triggers(spec) or {},
    })
  end

  -- lz.n always first, then loaded before not loaded; non-lazy before lazy; alphabetically
  table.sort(entries, function(a, b)
    if a.name == "lz.n" then return true end
    if b.name == "lz.n" then return false end
    if a.loaded ~= b.loaded then return a.loaded end
    if a.lazy ~= b.lazy then return not a.lazy end
    return a.name < b.name
  end)

  return entries, n_loaded, n_total
end

--- @param entries LazyStatusEntry[]
--- @param n_loaded number
--- @param n_total number
--- @return string[]
local function build_lines(entries, n_loaded, n_total)
  local lines = {}

  for _, e in ipairs(entries) do
    local trigger_str = #e.triggers > 0 and ("  [" .. table.concat(e.triggers, " | ") .. "]") or ""
    local icon = e.loaded and "[✓]" or "[✗]"
    table.insert(lines, string.format("%s %-30s  %s%s%s", icon, e.name, e.status, e.lazy and "  (Lazy)" or "", trigger_str))
  end

  -- compute width before building header so we can center it
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end
  width = math.min(width + 2, math.floor(vim.o.columns * MAX_WIDTH))

  local header = string.format("Loaded: %d  |  Not Loaded: %d  |  Total: %d", n_loaded, n_total - n_loaded, n_total)
  local pad = math.floor((width - #header) / 2)
  local separator = string.rep("─", width)

  -- blank line + centered header + separator on top
  table.insert(lines, 1, separator)
  table.insert(lines, 1, string.rep(" ", pad) .. header)
  table.insert(lines, 1, "")

  return lines, width
end

--- Open floating window with plugin load status
local function open()
  local entries, n_loaded, n_total = get_entries()
  local lines, width = build_lines(entries, n_loaded, n_total)
  local height = math.min(#lines, math.floor(vim.o.lines * MAX_HEIGHT))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "lazy-status"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = _G.window_border,
    title = "[ Lazy ]",
    title_pos = "center",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  })

  vim.wo[win].cursorline = true
  vim.wo[win].cursorlineopt = "line"

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<C-q>", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("Lazy", open, { desc = "Show plugin load status" })
