--- @brief
--- NeoVide global session & hot exit
---------------------------------------------------------------------
--- Single global session (Neovide only):
--- * Remembers all open files across restarts (no cwd scoping)
--- * Restores per-tab buffer scoping (via scope.nvim)
--- * Hot exit: unsaved buffers (modified or unnamed) are snapshotted
---   to disk and restored as modified buffers on next launch

--- Storage layout:
--- stdpath("state")/neovide-session/
---   session.vim -- mksession output (window/tab layout)
---   manifest.json -- per-buffer metadata (path, filetype, tab)
---   buffers/<id>.txt -- snapshot contents for unsaved buffers only
---------------------------------------------------------------------

if not vim.g.neovide then
  return
end

local session_dir = vim.fn.stdpath("state") .. "/neovide-session"
local session_file = session_dir .. "/session.vim"
local manifest_file = session_dir .. "/manifest.json"
local buffers_dir = session_dir .. "/buffers"

vim.fn.mkdir(buffers_dir, "p")

vim.opt.sessionoptions = { "buffers", "curdir", "folds", "tabpages", "winsize", "winpos" }

-- Filetypes we never want to snapshot or restore.
local skip_filetypes = {
  ["NvimTree"] = true,
  ["checkhealth"] = true,
  ["dap-view"] = true,
  ["dap-view-term"] = true,
  ["fzf"] = true,
  ["help"] = true,
  ["lspinfo"] = true,
  ["mini.map"] = true,
  ["minimap"] = true,
  ["qf"] = true,
  ["trouble"] = true,
  ["which_key"] = true,
}

local function should_track(buf)
  if not vim.api.nvim_buf_is_loaded(buf) then return false end
  if vim.bo[buf].buftype ~= "" then return false end
  if skip_filetypes[vim.bo[buf].filetype] then return false end
  return true
end

local function buffer_cursor(buf)
  local mark = vim.api.nvim_buf_get_mark(buf, '"')
  if mark[1] > 0 then return mark end
  return { 1, 0 }
end

-- Build a map: bufnr -> tab_index (1-based) describing which tab each buffer belongs to.
-- scope.nvim unlists buffers from tabs they don't belong to, so its cache is the source of truth for the non-current tabs;
-- the current tab's listed buffers aren't cached yet.
local function build_buf_to_tab()
  local map = {}
  local tabs = vim.api.nvim_list_tabpages()
  local tab_to_index = {}
  for i, t in ipairs(tabs) do tab_to_index[t] = i end

  -- scope's cache covers every tab except the current one
  local ok, scope_core = pcall(require, "scope.core")
  if ok and type(scope_core.cache) == "table" then
    for tab, bufs in pairs(scope_core.cache) do
      local idx = tab_to_index[tab]
      if idx then
        for _, b in ipairs(bufs) do map[b] = idx end
      end
    end
  end

  -- Current tab's listed buffers (only fill if not already mapped)
  local current_idx = tab_to_index[vim.api.nvim_get_current_tabpage()]
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and not map[buf] then
      map[buf] = current_idx
    end
  end

  return map
end

local function save()
  local ok, err = pcall(function()
    -- Wipe old snapshots
    vim.fn.delete(buffers_dir, "rf")
    vim.fn.mkdir(buffers_dir, "p")

    local manifest = {}
    local counter = 0
    local buf_to_tab = build_buf_to_tab()

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      -- Only track buffers that belong to a tab (listed now, or cached by scope in another tab).
      -- This includes buffers scope unlisted.
      if buf_to_tab[buf] and should_track(buf) then
        local name = vim.api.nvim_buf_get_name(buf)
        local modified = vim.bo[buf].modified
        local unnamed = name == ""

        -- Skip empty unnamed buffers (nothing worth restoring)
        local empty_unnamed = false
        if unnamed then
          local line_count = vim.api.nvim_buf_line_count(buf)
          local first = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
          empty_unnamed = line_count <= 1 and first == ""
        end

        if not (unnamed and empty_unnamed) then
          -- Snapshot contents only for unsaved buffers (modified or unnamed).
          -- Clean named buffers are restored from disk via mksession.
          local snapshot = modified or unnamed
          if snapshot then
            counter = counter + 1
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            vim.fn.writefile(lines, buffers_dir .. "/" .. counter .. ".txt", "b")
          end

          table.insert(manifest, {
            id = snapshot and counter or nil,
            path = unnamed and vim.NIL or name,
            filetype = vim.bo[buf].filetype,
            cursor = buffer_cursor(buf),
            tab_index = buf_to_tab[buf] or 1
          })
        end
      end
    end

    vim.fn.writefile({ vim.json.encode(manifest) }, manifest_file)

    -- Only save curdir if there are tracked buffers;
    local session_opts = { "buffers", "folds", "tabpages", "winsize", "winpos" }
    if #manifest > 0 then
      table.insert(session_opts, "curdir")
    end
    vim.opt.sessionoptions = session_opts

    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
  end)

  if not ok then
    vim.notify("Neovide session save failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

local function load()
  local ok, err = pcall(function()
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd("silent! source " .. vim.fn.fnameescape(session_file))
    end

    if vim.fn.filereadable(manifest_file) ~= 1 then return end

    local raw = table.concat(vim.fn.readfile(manifest_file), "\n")
    if raw == "" then return end

    local manifest = vim.json.decode(raw)
    if type(manifest) ~= "table" then return end

    local saved_tab = vim.api.nvim_get_current_tabpage()
    local tabs = vim.api.nvim_list_tabpages()

    -- tab_index (1-based) -> list of bufnrs, for rebuilding scope's cache
    local tab_bufs = {}

    for _, entry in ipairs(manifest) do
      pcall(function()
        local is_named = type(entry.path) == "string" and entry.path ~= ""
        local has_snap = entry.id ~= nil
        local buf

        if is_named then
          buf = vim.fn.bufadd(entry.path)
          vim.fn.bufload(buf)
        else
          buf = vim.api.nvim_create_buf(true, false)
        end

        -- Restore snapshot contents for unsaved buffers only.
        if has_snap then
          local snap = buffers_dir .. "/" .. entry.id .. ".txt"
          if vim.fn.filereadable(snap) == 1 then
            local lines = vim.fn.readfile(snap)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].modified = true
          end
        end

        if entry.filetype and entry.filetype ~= "" then
          vim.bo[buf].filetype = entry.filetype
        end
        if entry.cursor then
          pcall(vim.api.nvim_buf_set_mark, buf, '"', entry.cursor[1], entry.cursor[2], {})
        end

        local idx = entry.tab_index or 1
        tab_bufs[idx] = tab_bufs[idx] or {}
        table.insert(tab_bufs[idx], buf)
      end)
    end

    -- Rebuild scope's cache directly (keyed by tabpage handle) so each tab shows exactly its own buffers.
    local scope_ok, scope_core = pcall(require, "scope.core")
    if scope_ok then
      local cache = {}
      for idx, bufs in pairs(tab_bufs) do
        local tab = tabs[idx]
        if tab then cache[tab] = bufs end
      end
      scope_core.cache = cache
      scope_core.last_tab = saved_tab

      -- Unlist every restored buffer, then let scope list the active tab's buffers via its own on_tab_enter (reads cache[current]).
      for _, bufs in pairs(tab_bufs) do
        for _, b in ipairs(bufs) do
          if vim.api.nvim_buf_is_valid(b) then
            vim.bo[b].buflisted = false
          end
        end
      end

      if vim.api.nvim_tabpage_is_valid(saved_tab) then
        vim.api.nvim_set_current_tabpage(saved_tab)
      end
      pcall(scope_core.on_tab_enter)
    elseif vim.api.nvim_tabpage_is_valid(saved_tab) then
      vim.api.nvim_set_current_tabpage(saved_tab)
    end
  end)

  if not ok then
    vim.notify("Neovide session load failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- Auto-restore on startup, but only when Neovide was launched with no file args.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("neovide/session-load", { clear = true }),
  nested = true,
  once = true,
  callback = function()
    if vim.fn.argc() == 0 then load() end
  end
})

-- Auto-save on clean exit.
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("neovide/session-save", { clear = true }),
  callback = save
})

-- User commands
vim.api.nvim_create_user_command("NeovideSessionSave", save, { desc = "Neovide Save Session" })
vim.api.nvim_create_user_command("NeovideSessionLoad", load, { desc = "Neovide Load Session" })

vim.api.nvim_create_user_command("NeovideSessionDelete", function()
  vim.fn.delete(session_dir, "rf")
  vim.fn.mkdir(buffers_dir, "p")
  vim.notify("Neovide session deleted")
end, { desc = "Neovide Delete Session" })
