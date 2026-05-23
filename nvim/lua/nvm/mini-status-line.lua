--- @brief
--- mini.statusline

local Lazy = require("core/lazy")
local colors = require("colors/colors")

---------------------------------------------------------------------------
-- highlight cache + colored wrapping
---------------------------------------------------------------------------

local hl_cache = {}

--- Create (once) a highlight group with given fg and bg.
--- Returns the highlight group name.
local function make_hl(name, fg, bg)
  if hl_cache[name] then return name end
  vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg or colors.dark, bold = true })
  hl_cache[name] = true
  return name
end

--- Wrap `text` with `%#HL#...%#Restore#` so it shows colored on Fileinfo bg.
local function colorize(text, hl)
  if text == nil or text == "" then return "" end
  return string.format("%%#%s#%s%%#MiniStatuslineFileinfo#", hl, text)
end

--- Wrap text with hl on DevInfo bg (for branch/diff/diagnostics group).
local function colorize_dev(text, hl)
  if text == nil or text == "" then return "" end
  return string.format("%%#%s#%s%%#MiniStatuslineDevinfo#", hl, text)
end

---------------------------------------------------------------------------
-- Custom section components
---------------------------------------------------------------------------

-- show macro recording
local function show_macro(short)
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end
  if short then
    return "| Rec @" .. reg
  end
  return "| Recording @" .. reg
end

-- copilot status
local function show_copilot()
  if not vim.g.loaded_copilot then return "★" end
  if not vim.g.copilot_enabled then return "" end
  return vim.b.copilot_enabled == false and "" or ""
end

-- tree-sitter status
local function show_tree_sitter()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[bufnr] ~= nil then
    return "󰐆"
  end
  return ""
end

-- lsp clients
local lsp_clients = ""
local function update_lsp_clients()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, vim.trim(client.name))
  end
  lsp_clients = table.concat(names, " | ")
end

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
  callback = function()
    vim.schedule(function()
      update_lsp_clients()
      vim.cmd("redrawstatus")
    end)
  end
})

local function show_lsp_clients()
  return lsp_clients
end

local function progress_status()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if not vim.tbl_isempty(client.progress.pending or {}) then
      local msg = vim.tbl_values(client.progress.pending)[1]
      return (type(msg) == "string" and #msg > 0) and msg or "Loading"
    end
  end
  local ok, status = pcall(function() return vim.ui.progress_status() end)
  return ok and status or ""
end

-- selection count
local function show_selection_count()
  local mode = vim.fn.mode()
  if not (mode:find("[vVsS\22\19]")) then return "" end
  local s_start = vim.fn.line("v")
  local s_end = vim.fn.line(".")
  local lines = math.abs(s_end - s_start) + 1
  if mode == "V" or mode == "S" then
    return tostring(lines)
  end
  local chars = vim.fn.wordcount().visual_chars or 0
  return lines .. "x" .. chars
end

-- search count
local function show_search_count()
  if vim.v.hlsearch == 0 then return "" end
  local ok, s = pcall(vim.fn.searchcount, { recompute = true })
  if not ok or s.total == 0 or s.current == nil then return "" end
  if s.incomplete == 1 then return "?/?" end
  return string.format("[%d/%d]", s.current, s.total)
end

-- diff lewis6991/gitsigns -- added=green, modified=yellow, removed=red
local function show_diff()
  local s = vim.b.gitsigns_status_dict
  if not s then return "" end

  local parts = {}

  if (s.added or 0) > 0 then
    table.insert(parts, colorize_dev("+" .. s.added, make_hl("MiniStatuslineDiffAdd", colors.green, colors.surface1)))
  end

  if (s.changed or 0) > 0 then
    table.insert(parts, colorize_dev("~" .. s.changed, make_hl("MiniStatuslineDiffChange", colors.yellow, colors.surface1)))
  end

  if (s.removed or 0) > 0 then
    table.insert(parts, colorize_dev("-" .. s.removed, make_hl("MiniStatuslineDiffDelete", colors.red, colors.surface1)))
  end

  return table.concat(parts, " ")
end

-- Prefer gitsigns_head;
-- fall back to reading .git/HEAD from cwd so the branch shows when no file is open
local function show_branch()
  local head = vim.b.gitsigns_head
  if not head or head == "" then
    local git = vim.fs.find(".git", { upward = true, path = vim.uv.cwd() })[1]
    local f = git and io.open(git .. "/HEAD", "r")
    if f then
      local h = f:read("*l") or ""
      f:close()
      head = h:match("ref: refs/heads/(.+)$") or h:sub(1, 7)
    end
  end
  if not head or head == "" then return "" end
  return " " .. head
end

-- diagnostics with icons + per-severity colors
local function show_diagnostics()
  local levels = {
    { icon = "󰅚", sev = vim.diagnostic.severity.ERROR, hl = make_hl("MiniStatuslineDiagError", colors.red,    colors.surface1) },
    { icon = "󰀪", sev = vim.diagnostic.severity.WARN,  hl = make_hl("MiniStatuslineDiagWarn",  colors.yellow, colors.surface1) },
    { icon = "󰋽", sev = vim.diagnostic.severity.INFO,  hl = make_hl("MiniStatuslineDiagInfo",  colors.blue,   colors.surface1) },
    { icon = "󰌶", sev = vim.diagnostic.severity.HINT,  hl = make_hl("MiniStatuslineDiagHint",  colors.teal,   colors.surface1) },
  }
  local count = vim.diagnostic.count(0)
  local out = {}
  for _, lvl in ipairs(levels) do
    local n = count[lvl.sev] or 0
    if n > 0 then
      table.insert(out, colorize_dev(lvl.icon .. " " .. n, lvl.hl))
    end
  end
  return table.concat(out, " ")
end

-- filename (absolute, modified, readonly)
-- short=true returns only the basename (%t); otherwise the full path (%F).
local function show_filename(short)
  if short then return "%t%m%r" end
  return "%F%m%r"
end

-- file encoding
local function show_encoding()
  local enc = vim.bo.fileencoding
  if enc == "" then enc = vim.o.encoding end
  return enc
end

-- file format with icons
local fileformat_icons = {
  unix = "",
  dos  = "",
  mac  = "",
}
local function show_fileformat()
  local ff = vim.bo.fileformat
  return fileformat_icons[ff] or ff
end

-- filesize
local function show_filesize()
  local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
  if size <= 0 then return "" end
  if size < 1024 then return string.format("%dB", size) end
  if size < 1048576 then return string.format("%.1fk", size / 1024) end
  return string.format("%.1fM", size / 1048576)
end

-- filetype + colored icon via mini.icons
local function show_filetype()
  local ft = vim.bo.filetype
  if ft == "" then return "" end

  local ok, MiniIcons = pcall(require, "mini.icons")
  if not ok then return ft end

  -- Prefer file-based icon to get language-specific color, fall back to filetype
  local fname = vim.fn.expand("%:t")
  local icon, icon_hl
  if fname ~= "" then
    icon, icon_hl = MiniIcons.get("file", fname)
  end
  if not icon then
    icon, icon_hl = MiniIcons.get("filetype", ft)
  end
  if not icon then return ft end

  -- Re-create hl that uses MiniIcons fg on Fileinfo bg
  if icon_hl then
    local fg = vim.api.nvim_get_hl(0, { name = icon_hl, link = false }).fg
    if fg then
      local hl_name = "MiniStatuslineFT_" .. icon_hl
      if not hl_cache[hl_name] then
        vim.api.nvim_set_hl(0, hl_name, { fg = fg, bg = colors.dark, bold = true })
        hl_cache[hl_name] = true
      end
      return colorize(icon, hl_name) .. " " .. ft
    end
  end

  return icon .. " " .. ft
end

-- progress component (Top / Bot / xy%)
local function show_progress()
  local cur = vim.fn.line(".")
  local total = vim.fn.line("$")
  if cur == 1 then return "Top" end
  if cur == total then return "Bot" end
  return string.format("%2d%%%%", math.floor(cur / total * 100))
end

-- current location
local function show_location()
  return "%2v:%l/%L"
end

---------------------------------------------------------------------------
-- Mode highlights
---------------------------------------------------------------------------

local mode_colors = {
  Normal   = colors.blue,
  Insert   = colors.green,
  Visual   = colors.softcyan,
  Select   = colors.yellow,
  Replace  = colors.red,
  Command  = colors.pink,
  Terminal = colors.softpink,
}

local function set_base_hls()
  local function hl(name, fg)
    vim.api.nvim_set_hl(0, name, { bg = fg, fg = colors.dark, bold = true })
  end
  hl("MiniStatuslineModeNormal",  mode_colors.Normal)
  hl("MiniStatuslineModeInsert",  mode_colors.Insert)
  hl("MiniStatuslineModeVisual",  mode_colors.Visual)
  hl("MiniStatuslineModeSelect",  mode_colors.Select)
  hl("MiniStatuslineModeReplace", mode_colors.Replace)
  hl("MiniStatuslineModeCommand", mode_colors.Command)
  hl("MiniStatuslineModeOther",   mode_colors.Terminal)

  -- y-section variants: dark bg with mode-color fg (progress block)
  local function hl_y(name, fg)
    vim.api.nvim_set_hl(0, name, { bg = colors.dark, fg = fg, bold = true })
  end
  hl_y("MiniStatuslineProgNormal",  mode_colors.Normal)
  hl_y("MiniStatuslineProgInsert",  mode_colors.Insert)
  hl_y("MiniStatuslineProgVisual",  mode_colors.Visual)
  hl_y("MiniStatuslineProgSelect",  mode_colors.Select)
  hl_y("MiniStatuslineProgReplace", mode_colors.Replace)
  hl_y("MiniStatuslineProgCommand", mode_colors.Command)
  hl_y("MiniStatuslineProgOther",   mode_colors.Terminal)

  -- c-section variants: dark bg with mode-color fg (filename); Normal stays neutral
  local function hl_c(name, fg)
    vim.api.nvim_set_hl(0, name, { bg = colors.dark, fg = fg })
  end
  hl_c("MiniStatuslineFilenameNormal",  colors.text)
  hl_c("MiniStatuslineFilenameInsert",  mode_colors.Insert)
  hl_c("MiniStatuslineFilenameVisual",  mode_colors.Visual)
  hl_c("MiniStatuslineFilenameSelect",  mode_colors.Select)
  hl_c("MiniStatuslineFilenameReplace", mode_colors.Replace)
  hl_c("MiniStatuslineFilenameCommand", mode_colors.Command)
  hl_c("MiniStatuslineFilenameOther",   mode_colors.Terminal)

  -- b-like section (branch/diff/diagnostics)
  vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo",  { bg = colors.surface1, fg = colors.white, bold = true })

  -- c-like section (filename / middle)
  vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = colors.dark, fg = colors.text })

  -- x-like section (fileinfo)
  vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = colors.dark, fg = colors.text })

  -- inactive
  vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { bg = colors.dark, fg = colors.overlay0, bold = true })

  -- Reset cache (so per-color hls get recreated for new colorscheme)
  hl_cache = {}
end

-- Map mode_hl (a-style) -> y-style progress hl (dark bg, mode-color fg)
local prog_hl_map = {
  MiniStatuslineModeNormal  = "MiniStatuslineProgNormal",
  MiniStatuslineModeInsert  = "MiniStatuslineProgInsert",
  MiniStatuslineModeVisual  = "MiniStatuslineProgVisual",
  MiniStatuslineModeSelect  = "MiniStatuslineProgSelect",
  MiniStatuslineModeReplace = "MiniStatuslineProgReplace",
  MiniStatuslineModeCommand = "MiniStatuslineProgCommand",
  MiniStatuslineModeOther   = "MiniStatuslineProgOther",
}

-- Map mode_hl (a-style) -> c-style filename hl (dark bg, mode-color fg)
local filename_hl_map = {
  MiniStatuslineModeNormal  = "MiniStatuslineFilenameNormal",
  MiniStatuslineModeInsert  = "MiniStatuslineFilenameInsert",
  MiniStatuslineModeVisual  = "MiniStatuslineFilenameVisual",
  MiniStatuslineModeSelect  = "MiniStatuslineFilenameSelect",
  MiniStatuslineModeReplace = "MiniStatuslineFilenameReplace",
  MiniStatuslineModeCommand = "MiniStatuslineFilenameCommand",
  MiniStatuslineModeOther   = "MiniStatuslineFilenameOther",
}

---------------------------------------------------------------------------
-- Plugin
---------------------------------------------------------------------------
local function init_status_line()
  local MiniStatusline = require("mini.statusline")

  local function active()
    -- Section A
    local mode, mode_hl = MiniStatusline.section_mode({})
    mode = mode:upper()

    -- mini.statusline maps Select mode to MiniStatuslineModeVisual
    if vim.fn.mode():lower() == "s" then
      mode_hl = "MiniStatuslineModeSelect"
    end

    -- Section B: branch + diff + diagnostics
    local branch = show_branch()
    local diff = show_diff()
    local diagnostics = show_diagnostics()

    -- Section C: filename + macro + %S
    -- When narrow, show just the basename instead of full path; always show macro.
    local filename = show_filename(MiniStatusline.is_truncated(140))
    local macro = show_macro(MiniStatusline.is_truncated(140))

    -- Section X: selectioncount, searchcount, progress, lsp, copilot, treesitter, encoding, fileformat, filesize, filetype
    -- Join non-empty pieces with double spaces for visual separation.
    local x_parts = {
      show_selection_count(),
      show_search_count(),
      progress_status(),
      show_lsp_clients(),
      show_copilot(),
      show_tree_sitter(),
      show_encoding(),
      show_fileformat(),
      show_filesize(),
      show_filetype(),
    }

    local x_filtered = {}

    for _, v in ipairs(x_parts) do
      if v and v ~= "" then table.insert(x_filtered, v) end
    end

    local x = table.concat(x_filtered, "  ")

    -- Section Y: progress
    local progress = show_progress()

    -- Section Z: location
    local location = show_location()

    return MiniStatusline.combine_groups({
      { hl = mode_hl, strings = { mode } },
      { hl = "MiniStatuslineDevinfo", strings = { branch, diff, diagnostics } },
      { hl = filename_hl_map[mode_hl] or "MiniStatuslineFilenameNormal", strings = { filename, macro, "%S" } },

      "%<", -- if still too narrow, truncate filename rather than right side
      "%=", -- separator: pushes following groups to the right edge of the statusline

      { hl = "MiniStatuslineFileinfo", strings = { x } },
      { hl = prog_hl_map[mode_hl] or "MiniStatuslineProgNormal", strings = { progress } },
      { hl = mode_hl, strings = { location } },
    })
  end

  local function inactive()
    return "%#MiniStatuslineInactive#%F%="
  end

  MiniStatusline.setup({
    use_icons = true,
    content = {
      active = active,
      inactive = inactive,
    },
  })

  -- Apply highlights AFTER mini.statusline. Re-apply on every ColorScheme + VimEnter
  set_base_hls()
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("local/status-line", { clear  = true }),
    callback = function() vim.schedule(set_base_hls) end,
  })
end

Lazy.use {
  "nvim-mini/mini.statusline",
  lazy = false,
  priority = 512,
  config = init_status_line
}
