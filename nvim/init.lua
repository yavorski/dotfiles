------------------------------------------------------------
-- [[ neovim ]] [[ init.lua ]] --
------------------------------------------------------------

-- title filename
vim.opt.title = true

-- hide cmd line
vim.opt.cmdheight = 0

-- show status line
vim.opt.laststatus = 2

-- showcmd in statusline
vim.opt.showcmdloc = "statusline"

-- dark/light
vim.opt.background = "dark"

-- enable 24-bit RGB colors
vim.opt.termguicolors = true

-- set colorscheme
-- vim.cmd[[colorscheme catppuccin]]

-- syntax highlighting until match column
vim.opt.synmaxcol = 512

-- limit memory for pattern matching on single line
vim.opt.maxmempattern = 1024

-- disable word wrap
vim.opt.wrap = false

-- show line number
vim.opt.number = true

-- show relative line number
vim.opt.relativenumber = true

-- highlight line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- intro / messages / hit-enter prompts / ins-completion-menu
vim.opt.shortmess = "actIsoOFCW"

-- improve comment editing
vim.opt.formatoptions = "rqnl1j"

-- line lenght marker
-- vim.opt.colorcolumn = "128"

-- signcolumn
vim.opt.signcolumn = "yes"

-- enable mouse
vim.opt.mouse = "a"

-- min number of screen lines above/below the cursor
vim.opt.scrolloff = 4

-- min number of screen columns left/right the cursor
vim.opt.sidescrolloff = 4

-- screen line scrolling
vim.opt.smoothscroll = true

-- horizontal splits will be below
vim.opt.splitbelow = true

-- vertical splits will be to the right
vim.opt.splitright = true

-- reduce scroll during window split
vim.opt.splitkeep = "screen"

-- system clipboard
-- vim.opt.clipboard = "unnamedplus"

-- ignore case in search patterns
vim.opt.ignorecase = true

-- override the "ignorecase" option if the search containse upper characters
vim.opt.smartcase = true

-- show search results while typing
vim.opt.incsearch = true

-- popup/complete menu
vim.opt.pumheight = 24

-- built-in complete menu - popup
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }

-- better diff alignment by considering indentation changes
vim.opt.diffopt:append("indent-heuristic")

-- reload file on external change
vim.opt.autoread = true

-- LF line endings
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "mac", "dos" }

-- backups
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.writebackup = false

-- tabs, indent
vim.opt.tabstop = 2           -- 1 tab == 2 spaces
vim.opt.shiftwidth = 2        -- indent is 2 spaces
vim.opt.softtabstop = 2       -- insert 2 spaces when tab is pressed
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.smartindent = true    -- autoindent new lines

------------------------------------------------------------
-- list
------------------------------------------------------------

vim.opt.list = false
vim.opt.listchars = {
  eol = " ",
  tab = "» ",
  trail = "~",
  space = "·",
}

------------------------------------------------------------
-- Folds -> vim.opt.statuscolumn = "%C%s%l "
------------------------------------------------------------

vim.opt.fillchars = {
  fold = " ", -- filling foldtext
  foldsep = " ", -- fold middle marker
  foldopen = "", -- arrow for open folds
  foldclose = "" -- arrow for closed folds
}

vim.opt.foldenable = false     -- Enable manually

vim.opt.foldcolumn = "0"       -- Fold column width
vim.opt.foldmethod = "indent"  -- Set folding method

vim.opt.foldtext = ""          -- Off fold text
vim.opt.foldlevel = 99         -- Don't fold on start
vim.opt.foldnestmax = 5        -- Fold depth max level
vim.opt.foldlevelstart = 99    -- Auto fold start level

vim.g.markdown_folding = 1     -- Fold by heading in markdown files

-- tree-sitter folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

------------------------------------------------------------
-- grep/vimgrep/ripgrep
------------------------------------------------------------

-- default grep program
-- vim.opt.grepprg = "grep -n $* /dev/null"

-- use ripgrep instead of grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --follow"

------------------------------------------------------------
-- Leader
------------------------------------------------------------

-- Space <Leader>
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

-- Default <Leader>
-- vim.g.mapleader = [[\]]
-- vim.g.maplocalleader = [[\]]

------------------------------------------------------------
-- Providers
------------------------------------------------------------

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

------------------------------------------------------------
-- Filetypes Auto Detection
------------------------------------------------------------

vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
  pattern = {
    [ ".*/waybar/config" ] = "jsonc",
    [ ".*/ghostty/config" ] = "conf",
    [ ".*/hypr/.*%.conf" ] = "hyprlang",
  }
})

------------------------------------------------------------
-- system
------------------------------------------------------------

local sysname = vim.loop.os_uname().sysname
local is_linux = sysname == "Linux"
local is_windows = sysname == "Windows_NT"
local is_wsl = vim.fn.has("wsl") == 1
local is_wsl_or_windows = is_wsl or is_windows
local is_neovide = vim.g.neovide == true
local is_ghostty = vim.env.TERM_PROGRAM == "ghostty"

------------------------------------------------------------
-- window border
------------------------------------------------------------

--- @type "bold"|"double"|"none"|"rounded"|"shadow"|"single"|"solid"
local win_border = (is_ghostty or is_neovide) and "rounded" or "bold"

-- global
vim.opt.winborder = win_border

------------------------------------------------------------
-- Diagnostics Config
------------------------------------------------------------

vim.diagnostic.config({
  underline = false,
  severity_sort = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = { current_line = true },
  signs = {
    text = {
      [ vim.diagnostic.severity.HINT ] = "★",
      [ vim.diagnostic.severity.INFO ] = "▪",
      [ vim.diagnostic.severity.WARN ] = "◮",
      [ vim.diagnostic.severity.ERROR ] = "",
    }
  }
})

------------------------------------------------------------
-- Auto CMD
------------------------------------------------------------

-- enable all filetype plugins
-- vim.cmd[[filetype plugin indent on]]

-- enable syntax highlighting
-- if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

-- trim trailing whitespace on save
-- vim.cmd[[autocmd BufWritePre * :%s/\s\+$//e]]

-- use tabs
vim.cmd[[autocmd FileType make setlocal noexpandtab]]

-- disable sign column
vim.cmd[[autocmd FileType help setlocal signcolumn=no]]

-- disable relative numbers
vim.cmd[[autocmd FileType qf,lhelp,lquickfix,dbout setlocal norelativenumber]]

-- don't auto comment new lines
vim.cmd[[autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o]]

-- highlight on yank
vim.cmd[[autocmd TextYankPost * silent! lua vim.hl.on_yank({ higroup = "YankHighlight" })]]

-- 2 spaces for selected filetypes
vim.cmd[[autocmd FileType xml,html,css,json,lua,yaml,markdown setlocal shiftwidth=2 tabstop=2 expandtab]]

------------------------------------------------------------
-- LF CMD
------------------------------------------------------------

-- Normalize Line Endings
-- Executing a command with : in visual line/block mode changes mode to normal mode, making it unclear what the previous mode was.
-- Checking the count option helps: -1 indicates "no range," implying the command was executed from normal mode (if only considering normal and visual modes).
local function normalize_line_endings(options)
  local cursor_position = vim.api.nvim_win_get_cursor(0)

  if options.count == -1 then
    vim.cmd("silent! keepalt keepjumps %s/\r//g")
  else
    vim.cmd("silent! keepalt keepjumps '<,'>s/\r//g")
  end

  vim.api.nvim_win_set_cursor(0, cursor_position)
end

-- user command
vim.api.nvim_create_user_command("NormalizeLineEndings", normalize_line_endings, { nargs = "?", range = "%", addr = "lines", desc = "Normalize Line Endings" })

-- Force convert file to LF
local function forcelf(options)
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd("set fileformat=unix")
  normalize_line_endings(options)
  vim.api.nvim_win_set_cursor(0, cursor_position)
end

-- user command
vim.api.nvim_create_user_command("ForceLF", forcelf, { nargs = "?", range = "%", addr = "lines", desc = "Set LF Line Endings" })

-- Toggle Conceal CRLF ^M
local function toggle_conceal_crlf()
  if vim.wo.conceallevel > 0 then
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
    vim.cmd("syntax clear ExtraCR")
    vim.notify("Conceal CRLF -> OFF")
  else
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "n"
    vim.cmd("syntax match ExtraCR /\\r/ conceal")
    vim.notify("Conceal CRLF -> ON")
  end
end

-- user command
vim.api.nvim_create_user_command("ToggleConcealCRLF", toggle_conceal_crlf, { desc = "Toggle conceal of carriage return (^M) characters" })

------------------------------------------------------------
-- Buffer Only CMD
------------------------------------------------------------

local function buffer_only(discard_modified_buffers)
  vim.cmd("silent! tabonly!")

  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_buffer_ft = vim.api.nvim_get_option_value("filetype", { buf = current_buffer })

  if current_buffer_ft == "NvimTree" or current_buffer_ft == "dbui" or current_buffer_ft == "dbout" then
    return vim.notify(current_buffer_ft, vim.log.levels.INFO)
  end

  for _, buffer in ipairs(buffers) do
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
    local stopper = buffer == current_buffer or ft == "minimap" or ft == "NvimTree" or ft == "dbui" or ft == "dbout" or not vim.api.nvim_buf_is_valid(buffer)

    if not stopper then
      if discard_modified_buffers then
        vim.api.nvim_buf_delete(buffer, { force = true })
      else
        if vim.api.nvim_get_option_value("modified", { buf = buffer }) then
          vim.api.nvim_set_option_value("buflisted", true, { buf = buffer })
        else
          vim.api.nvim_buf_delete(buffer, { force = false })
        end
      end
    end
  end
end

-- user command
vim.api.nvim_create_user_command("BufferOnly", function(opts) buffer_only(opts.bang) end, { bang = true })

------------------------------------------------------------
-- Popup Menu Keymaps
-- Accept with <C-e>
-- Cancel/Revert with <C-c>
------------------------------------------------------------

local PUM = {
  is_canceled = false,
  is_listener_attached = false,
  namespace_id = vim.api.nvim_create_namespace("popup_menu_listener"),
  keys = {
    CTRL_C = vim.api.nvim_replace_termcodes("<C-c>", true, false, true),
    CTRL_E = vim.api.nvim_replace_termcodes("<C-e>", true, false, true),
    CTRL_Y = vim.api.nvim_replace_termcodes("<C-y>", true, false, true),
  }
}

PUM.on_key = function(key)
  if vim.fn.pumvisible() ~= 1 then return end

  if key == PUM.keys.CTRL_C then
    PUM.is_canceled = true
    vim.api.nvim_feedkeys(PUM.keys.CTRL_E, "i", false)
    return ""
  elseif key == PUM.keys.CTRL_E and not PUM.is_canceled then
    vim.api.nvim_feedkeys(PUM.keys.CTRL_Y, "i", false)
    return ""
  end

  PUM.is_canceled = false
end

PUM.add_listener = function()
  if not PUM.is_listener_attached then
    vim.on_key(PUM.on_key, PUM.namespace_id)
    PUM.is_listener_attached = true
  end
end

PUM.remove_listener = function()
  if PUM.is_listener_attached then
    vim.on_key(nil, PUM.namespace_id)
    PUM.is_listener_attached = false
  end
end

-- Initialize PUM - add the event handler on popup open and remove it on close
PUM.init = function ()
  vim.api.nvim_create_autocmd("CompleteChanged", { callback = PUM.add_listener })
  vim.api.nvim_create_autocmd("CompleteDone", { callback = PUM.remove_listener })
end

-- init
PUM.init()

------------------------------------------------------------
-- Keymaps
------------------------------------------------------------

-- disable built in |m| key - marks operations
vim.keymap.set({ "n", "v", "x" }, "m", "<Nop>", { silent = true })

-- disable built in |s| key - deletes char under cursor
-- vim.keymap.set({ "n", "v", "x" }, "s", "<Nop>", { silent = true })

-- save file/buffer
vim.keymap.set("n", "<Leader>w", "<cmd>write<CR>", { desc = "Write File" })

-- match brackets remap
-- vim.keymap.set({ "n", "v", "x" }, "mm", "%", { silent = true })
vim.keymap.set("n", "mm", "<Plug>(MatchitNormalForward)", { silent = true })
vim.keymap.set({ "v", "x" }, "mm", "<Plug>(MatchitVisualForward)", { silent = true })

-- comment - additional keymaps
vim.api.nvim_set_keymap("v", "<C-c>", "gc", { silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", "gcc", { silent = true })

-- copy/paste system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { silent = true, desc = "[sc] Yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>Y", [["+yy]], { silent = true, desc = "[sc] Yank Line" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", [["+p]], { silent = true, desc = "[sc] Paste After" })
vim.keymap.set({ "n", "v", "x" }, "<leader>P", [["+P]], { silent = true, desc = "[sc] Paste Before" })
vim.keymap.set({ "v", "x" }, "<leader>d", [["+d]], { silent = true, desc = "[sc] Yank Delete" })
vim.keymap.set({ "n" }, "<leader>%y", "<cmd>silent! %y+<cr>", { silent = true, desc = "[sc] Yank Buffer" })

-- buffer navigation -standard prev/next
vim.keymap.set("n", "gp", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "gn", "<cmd>bnext<cr>", { silent = true })

-- buffer navigation require nvim-lualine/lualine.nvim plugin
vim.keymap.set("n", "gb$", "<cmd>LualineBuffersJump $<cr>", { silent = true })
vim.keymap.set("n", "gb1", "<cmd>LualineBuffersJump! 1<cr>", { silent = true })
vim.keymap.set("n", "gb2", "<cmd>LualineBuffersJump! 2<cr>", { silent = true })
vim.keymap.set("n", "gb3", "<cmd>LualineBuffersJump! 3<cr>", { silent = true })
vim.keymap.set("n", "gb4", "<cmd>LualineBuffersJump! 4<cr>", { silent = true })
vim.keymap.set("n", "gb5", "<cmd>LualineBuffersJump! 5<cr>", { silent = true })
vim.keymap.set("n", "gb6", "<cmd>LualineBuffersJump! 6<cr>", { silent = true })
vim.keymap.set("n", "gb7", "<cmd>LualineBuffersJump! 7<cr>", { silent = true })
vim.keymap.set("n", "gb8", "<cmd>LualineBuffersJump! 8<cr>", { silent = true })
vim.keymap.set("n", "gb9", "<cmd>LualineBuffersJump! 9<cr>", { silent = true })
vim.keymap.set("n", "gb0", "<cmd>LualineBuffersJump! 10<cr>", { silent = true })

------------------------------------------------------------
-- Color Scheme
------------------------------------------------------------

local Dark = {
  mocha = {
    mauve  = "#cba6f7",
    red    = "#f38ba8",
    green  = "#a6e3a1",
    yellow = "#f9e2af",
  },

  colors = {
    none      = "NONE",
    white     = "#ffffff", -- [*] White
    rosewater = "#f5e0dc", -- Winbar
    flamingo  = "#f2cdcd", -- Target word
    pink      = "#ff1493", -- [!] Just pink
    softpink  = "#f94ba6", -- [*] Soft pink
    darkpink  = "#f40064", -- [*] Dark pink
    mauve     = "#c678dd", -- [!] Tag
    purple    = "#bd5eff", -- [*]
    magenta   = "#ff5ef1", -- [*]
    red       = "#e95678", -- [!] Error
    maroon    = "#d16d9e", -- [!] Lighter red
    peach     = "#f5a97f", -- [!] Number
    yellow    = "#faf76e", -- [!] Warning
    green     = "#4bf99e", -- [!] Diff add
    teal      = "#94e2d5", -- Hint
    sky       = "#89dceb", -- Operator
    sapphire  = "#36d0e0", -- Constructor
    blue      = "#4ba6f9", -- [!] Diff changed
    lavender  = "#89b4fa", -- [!] CursorLine Nr
    text      = "#cdd6f4", -- Default FG
    subtext1  = "#bac2de", -- Indicator
    subtext0  = "#a6adc8", -- Float title
    overlay2  = "#9399b2", -- Popup FG
    overlay1  = "#7f849c", -- Conceal color
    overlay0  = "#6c7086", -- Fold color
    surface2  = "#585b70", -- Default comment
    surface1  = "#45475a", -- Darker comment
    surface0  = "#313244", -- Darkest comment
    trick     = "#1abc9c", -- [*] Trick
    stealth   = "#14ff80", -- [*] Type
    skyblue   = "#54b9f7", -- [*] Sky blue
    softcyan  = "#4bf9f5", -- [*] Soft cyan
    mantle    = "#181825", -- [!] Dark 13
    coal      = "#161622", -- [*] Dark 12
    slate     = "#14141f", -- [!] Dark 11
    crust     = "#11111b", -- [!] Dark 10
    dusk      = "#0f0f17", -- [*] Dark 9
    night     = "#0d1011", -- [*] Dark 8
    base      = "#0b0b10", -- [!] Dark 7 -- Default BG
    dark      = "#0a0a0f", -- [*] Dark 6
    darky     = "#07070c", -- [*] Dark 5
    matter    = "#050509", -- [*] Dark 4
    abyss     = "#030306", -- [*] Dark 3
    cosmic    = "#020204", -- [*] Dark 2
    void      = "#010102", -- [*] Dark 1
    black     = "#000000", -- [*] Dark 0 -- Just Black
  }
}

function Dark.editor()
  local mocha, colors = Dark.mocha, Dark.colors

  return {
    LineNr = { bg = colors.dusk },
    CursorLineNr = { bg = colors.darky },

    SignColumn = { bg = colors.dusk },
    SignColumnSB = { bg = colors.dusk },
    CursorLineSign = { bg = colors.darky },

    Folded = { bg = colors.surface0 },
    FoldColumn = { bg = colors.dusk },
    CursorLineFold = { fg = colors.red, bg = colors.darky },

    MsgArea = { bg = colors.darky},
    CursorLine = { bg = colors.matter },
    VertSplit = { fg = colors.darky, bg = colors.darky },
    WinSeparator = { fg = colors.darky, bg = colors.darky },

    NormalFloat = { bg = colors.base }, -- Floating windows
    FloatBorder = { fg = colors.blue, bg = colors.base }, -- Border for floating windows

    Visual = { bg = colors.surface0 },
    VisualNOS = { bg = colors.surface0 },

    Pmenu = { bg = colors.darky },
    PmenuSbar = { bg = colors.mantle },
    PmenuThumb = { bg = colors.teal },

    Search = { fg = colors.base, bg = mocha.yellow },
    IncSearch = { fg = colors.mantle, bg = mocha.red },
    CurSearch = { fg = colors.mantle, bg = mocha.red },

    YankHighlight = { fg = colors.base, bg = mocha.green },
    LspReferenceTarget = { }, -- <K> clear hover highlighting targeted word

    -- nvim mini
    MiniJump = { fg = colors.stealth, bg = colors.darkpink },
    MiniTrailspace = { bg = colors.red },
    MiniIndentscopeSymbol = { fg = colors.red },
    MiniMapNormal = { bg = colors.none },
    MiniMapSymbolLine = { fg = colors.pink },
    MiniMapSymbolView = { fg = colors.black },
    MiniNotifyNormal = { bg = colors.black },
    MiniNotifyBorder = { fg = colors.black, bg = colors.black },

    -- nvim marks -- not working
    -- MarkSignHL = { bg = colors.none },
    -- MarkSignNumHL = { fg = colors.none, bg = colors.none },

    -- nvim tree
    NvimTreeNormal = { bg = colors.base },
    NvimTreeCursorLine = { bg = colors.mantle },
    NvimTreeRootFolder = { fg = colors.peach },
    NvimTreeFolderName = { fg = colors.blue },
    NvimTreeFolderIcon = { fg = colors.skyblue },
    NvimTreeWinSeparator = { fg = colors.darky, bg = colors.darky },

    -- nvim gitsigns
    GitSignsAdd = { fg = colors.green, bg = colors.none },
    GitSignsChange = { fg = colors.yellow, bg = colors.none },
    GitSignsDelete = { fg = colors.red, bg = colors.none },

    -- noice
    NoiceDark = { bg = colors.mantle },

    -- which-key
    WhichKey = { bg = colors.crust },
    WhichKeyNormal = { bg = colors.crust },

    -- trouble
    TroubleNormal = { bg = colors.crust },
    TroubleNormalNC = { bg = colors.crust },
    TroublePos = { fg = colors.subtext1, bg = colors.none },
    TroubleCount = { fg = colors.green, bg = colors.none },

    -- blink
    BlinkCmpMenu = { bg = colors.base },
    BlinkCmpMenuBorder = { fg = colors.sapphire, bg = colors.base },
    BlinkCmpDoc = { bg = colors.base },
    BlinkCmpDocBorder = { fg = colors.sapphire, bg = colors.base },

    -- copilot
    CopilotSuggestion = { style = { "italic" } },

    -- nvim fzf-lua
    FzfLuaNormal = { fg = colors.text, bg = colors.mantle },
    FzfLuaBorder = { fg = colors.blue, bg = colors.mantle },
    FzfLuaCursorLine = { bg = colors.darky },

    FzfLuaPreviewNormal = { bg = colors.crust },
    FzfLuaPreviewBorder = { fg = colors.crust, bg = colors.crust },
    FzfLuaPreviewTitle = { fg = colors.blue, bg = colors.black },

    FzfLuaFzfNormal = { bg = colors.mantle },
    FzfLuaFzfMatch = { fg = colors.blue },
    FzfLuaFzfSeparator = { fg = colors.black },
    FzfLuaFzfInfo = { fg = colors.flamingo },
    FzfLuaFzfPointer = { fg = colors.green },
    FzfLuaFzfBorder = { fg = colors.black },
    FzfLuaFzfScrollbar = { fg = colors.peach },
    FzfLuaFzfGutter = { link = "FzfLuaNormal" },
  }
end

function Dark.syntax()
  local colors = Dark.colors

  return {
    -- nvim
    Include = { fg = colors.pink },
    Constant = { fg = colors.peach },
    Exception = { fg = colors.red },
    Repeat = { fg = colors.maroon },
    -- Type = { fg = colors.stealth },
    -- Structure = { fg = colors.peach },
    -- StorageClass = { fg = colors.yellow },

    -- lsp
    ["@lsp.type.comment"] = { link = "@lsp" }, -- disable lsp comments, use tree-sitter instead

    -- tree-sitter
    ["@constant"] = { fg = colors.peach },
    ["@constant.builtin"] = { fg = colors.pink },
    ["@exception"] = { fg = colors.red },
    ["@keyword.return"] = { fg = colors.red },
    ["@keyword.export"] = { fg = colors.pink },
    ["@keyword.operator"] = { fg = colors.stealth },
    ["@keyword.coroutine"] = { fg = colors.stealth },

    -- rust
    ["@lsp.typemod.keyword.async.rust"] = { fg = colors.stealth },
    ["@lsp.typemod.keyword.await.rust"] = { fg = colors.stealth },

    -- dotnet tree-sitter
    ["@type.c_sharp"] = { fg = colors.trick },
    ["@type.qualifier.c_sharp"] = { link = "@keyword" },
    ["@keyword.modifier.c_sharp"] = { fg = colors.mauve },
    ["@keyword.operator.c_sharp"] = { fg = colors.yellow },
    ["@keyword.coroutine.c_sharp"] = { fg = colors.yellow },

    -- dotnet lsp semantic tokens
    ["@lsp.type.class.cs"] = { link = "@lsp" }, -- disable styling attributes as classes
    ["@lsp.type.keyword.cs"] = { link = "@lsp" }, -- disable "keyword" since everything is a "keyword" and uses only 1 color
    ["@lsp.type.struct.cs"] = { fg = colors.peach },
    ["@lsp.type.enum.cs"] = { fg = colors.flamingo },
    ["@lsp.type.interface.cs"] = { fg = colors.rosewater },
    -- ["@lsp.typemod.class.static.cs"] = { fg = colors.softcyan },
    -- ["@lsp.type.namespace.cs"] = { fg = colors.peach, style = { "italic" } },

    -- css
    ["cssPseudo"] = { fg = colors.mauve },
    ["cssBoxProp"] = { link = "@property" },
    ["cssFontProp"] = { link = "@property" },
    ["cssTextProp"] = { link = "@property" },
    ["cssColorProp"] = { link = "@property" },
    ["cssVisualProp"] = { link = "@property" },
    ["cssBorderProp"] = { link = "@property" },
    ["cssAdvancedProp"] = { link = "@property" },
    ["cssBackgroundProp"] = { link = "@property" },

    -- stylus
    ["stylusId"] = { fg = colors.pink },
    ["stylusClass"] = { fg = colors.red },
    ["stylusImport"] = { fg = colors.pink },
    ["stylusVariable"] = { fg = colors.green },
    ["stylusProperty"] = { link = "@property" },

    -- xml
    ["xmlAttrib"] = { fg = colors.peach }
  }
end

function Dark.lualine()
  local line = { }
  local colors = Dark.colors;

  local function colorize(c, text)
    return {
      a = { bg = c, fg = colors.dark, gui = "bold" },
      b = { bg = colors.surface1, fg = colors.white, gui = "bold" },
      c = { bg = colors.dark, fg = text or c },
      x = { bg = colors.dark, fg = colors.text },
      y = { bg = colors.dark, fg = c }
    }
  end

  line.normal = colorize(colors.blue, colors.text)
  line.insert = colorize(colors.green)
  line.visual = colorize(colors.softcyan)
  line.select = colorize(colors.yellow)
  line.replace = colorize(colors.red)
  line.command = colorize(colors.pink)
  line.terminal = colorize(colors.softpink)

  line.inactive = {
    a = { bg = colors.dark, fg = colors.skyblue, gui = "bold" },
    b = { bg = colors.dark, fg = colors.surface1, gui = "bold" },
    c = { bg = colors.dark, fg = colors.overlay0, gui = "bold" },
  }

  return line
end

------------------------------------------------------------
-- Lazy
------------------------------------------------------------
-- ~/.cache/nvim
-- ~/.local/share/nvim/lazy
-- ~/.local/state/nvim/lazy
-- ~/.config/nvim/lazy-lock.json
------------------------------------------------------------
-- nvim --headless "+Lazy! sync" +qa
------------------------------------------------------------

local Lazy = {
  plugins = {},
  path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  repository = "https://github.com/folke/lazy.nvim.git",
  config = {
    ui = {
      border = win_border,
      backdrop = 100
    },
    rocks = {
      enabled = false
    },
    defaults = {
      lazy = true, -- lazy load plugins by default
      version = false, -- always use the latest git commit
    },
    performance = {
      rtp = {
        disabled_plugins = { "gzip", "tutor", "tohtml", "tarPlugin", "zipPlugin", "netrwPlugin" }
      }
    }
  }
}

-- lazy install
function Lazy.install()
  if not vim.uv.fs_stat(Lazy.path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", Lazy.repository, Lazy.path })
  end

  -- run time path
  vim.opt.rtp:prepend(Lazy.path)
end

-- lazy add plugin
function Lazy.use(plugin)
  table.insert(Lazy.plugins, plugin)
end

-- setup all
function Lazy.setup()
  require("lazy").setup(Lazy.plugins, Lazy.config)
end

------------------------------------------------------------
-- Lazy plugins
------------------------------------------------------------

-- colorscheme
Lazy.use {
  "catppuccin/nvim",
  lazy = false,
  priority = 1024,
  opts = {
    kitty = false,
    flavour = "mocha",
    background = {
      dark = "mocha",
      light = "mocha"
    },
    term_colors = true,
    transparent_background = false,
    integrations = {
      fzf = true,
      mini = true,
      noice = true,
      nvimtree = true,
      diffview = true,
      blink_cmp = true,
      which_key = true,
      lsp_trouble = true,
      copilot_vim = true,
    },
    color_overrides = { mocha = Dark.colors },
    highlight_overrides = {
      mocha = function(colors)
        return vim.tbl_extend("error", Dark.editor(), Dark.syntax())
      end
    },
  },
  config = function(_, options)
    require("catppuccin").setup(options)
    vim.cmd("colorscheme catppuccin-mocha")
  end
}

-- utility lib
Lazy.use { "nvim-lua/plenary.nvim" }

-- rust.vim
Lazy.use { "rust-lang/rust.vim", ft = "rust" }

-- stylus syntax
Lazy.use { "wavded/vim-stylus", ft = "stylus" }

-- Microsoft.CodeAnalysis.LanguageServer
Lazy.use { "seblyng/roslyn.nvim", ft = "cs", config = true }

-- scope buffers to tabs
Lazy.use { "tiagovla/scope.nvim", event = "VeryLazy", config = true }

-- use tree-sitter to auto close/rename html tag
Lazy.use {
  "windwp/nvim-ts-autotag",
  ft = { "html", "cshtml", "razor", "htmlangular" },
  opts = {
    aliases = {
      ["razor"] = "html",
      ["cshtml"] = "html"
    },
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true
    }
  }
}

-- put, put_text, setup_auto_root, setup_restore_cursor, zoom
Lazy.use { "echasnovski/mini.misc", event = "VeryLazy", config = true }

-- jump/repeat with f, F, t, T on multiple lines
Lazy.use { "echasnovski/mini.jump", event = "VeryLazy", config = true }

-- move any selection in any direction - [v] <Alt+hjkl>
Lazy.use { "echasnovski/mini.move", event = "VeryLazy", config = true }

-- auto pairs
Lazy.use { "echasnovski/mini.pairs", event = "VeryLazy", config = true }

-- auto comment - [n,v] <gc>
Lazy.use { "echasnovski/mini.comment", event = "VeryLazy", config = true }

-- surround - add, delete, replace, find, highlight - [n,v] <sa> <sd> <sr>
Lazy.use { "echasnovski/mini.surround", event = "VeryLazy", config = true }

-- mini icons
Lazy.use {
  "echasnovski/mini.icons",
  event = "VeryLazy",
  config = function()
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()
  end
}

-- visualize and work with indent scope animated
Lazy.use {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
  opts = {
    draw = {
      delay = 64,
      animation = function() return 0 end
    },
    options = {
      n_lines = 128
    }
  },
  init = function()
    vim.cmd[[autocmd FileType NvimTree lua vim.b.miniindentscope_disable = true]]
  end
}

-- minimap - window with buffer text overview
Lazy.use {
  "echasnovski/mini.map",
  event = "VeryLazy",
  opts = {
    window = {
      width = 1,
      show_integration_count = false
    }
  },
  config = function(_, options)
    require("mini.map").setup(options)
    require("mini.map").open()
  end
}

-- highlight patterns / display #rrggbb colors
Lazy.use {
  "echasnovski/mini.hipatterns",
  ft = { "lua", "conf", "css", "scss", "stylus", "html", "toml", "yml", "yaml", "markdown" },
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color()
      }
    })
  end
}

-- split/join code blocks, fn args, arrays, tables - [n,v] <sj>
Lazy.use {
  "echasnovski/mini.splitjoin",
  event = "VeryLazy",
  config = function()
    local splitjoin = require("mini.splitjoin")

    splitjoin.setup({
      mappings = { toggle = "sj" },
      join = {
        hooks_post = {
          splitjoin.gen_hook.pad_brackets(),
          splitjoin.gen_hook.del_trailing_separator(),
        }
      }
    })
  end
}

-- trim/highlight trailing whitespace
Lazy.use {
  "echasnovski/mini.trailspace",
  event = "VeryLazy",
  config = function()
    require("mini.trailspace").setup({})

    local trim = function()
      MiniTrailspace.trim()
      MiniTrailspace.trim_last_lines()
    end

    vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = trim })
    vim.api.nvim_create_user_command("TrimTralingWhiteSpace", trim, { desc = "Trim Trailing White Space" })
  end
}

-- delete buffers without losing window layout
Lazy.use {
  "echasnovski/mini.bufremove",
  cmd = { "Bdelete", "Bwipeout" },
  keys = {
    { "<leader>q", "<cmd>Bdelete<cr>", silent = true, desc = "Quit Buffer" },
    { "<leader>e", "<cmd>Bwipeout<cr>", silent = true, desc = "Wipeout Buffer" }
  },
  config = function()
    vim.api.nvim_create_user_command("Bdelete", function(opts) require("mini.bufremove").delete(tonumber(opts.args) or 0, opts.bang) end, { bang = true, nargs = "?" })
    vim.api.nvim_create_user_command("Bwipeout", function(opts) require("mini.bufremove").wipeout(tonumber(opts.args) or 0, opts.bang) end, { bang = true, nargs = "?" })
  end
}

-- inline diff provider for codecompanion
Lazy.use {
  "echasnovski/mini.diff",
  config = function()
    local MiniDiff = require("mini.diff")
    MiniDiff.config.view.priority = -1
    MiniDiff.config.delay.text_change = 10000
    MiniDiff.config.source = MiniDiff.gen_source.none()
    for key, _ in pairs(MiniDiff.config.mappings) do MiniDiff.config.mappings[key] = "" end
    for key, _ in pairs(MiniDiff.config.view.signs) do MiniDiff.config.view.signs[key] = "" end
    MiniDiff.setup()
  end
}

-- show notifications
Lazy.use {
  "echasnovski/mini.notify",
  event = "VeryLazy",
  enabled = false,
  opts = {
    content = {
      format = function(notification)
        return notification.msg
      end,
    },
    window = {
      config = {
        border = "solid",
        row = 2,
        col = vim.o.columns - 2
      }
    }
  },
  config = function(_, options)
    require("mini.notify").setup(options)
    vim.notify = require("mini.notify").make_notify()
  end
}

-- file explorer sidebar
Lazy.use {
  "nvim-tree/nvim-tree.lua",
  cmd = "NvimTreeToggle",
  opts = {
    git = { timeout = 2048 },
    sync_root_with_cwd = true,
    update_focused_file = { enable = true },
  },
  keys = {
    { [[<leader>\r]], "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { [[<leader>\f]], "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { [[<leader>\F]], "<cmd>NvimTreeFindFile!<cr>", silent = true, desc = "NvimTreeFindFile!" },
    { [[<leader>\\]], function() require("nvim-tree.api").tree.toggle({ focus = false }) end, silent = true, desc = "NvimTreeToggle" },
  }
}

-- show marks in the sign column
Lazy.use {
  "chentoast/marks.nvim",
  keys = {
    { "gmm", function() require("marks").next() end, silent = true, desc = "Go to next mark" },
    { "gmp", function() require("marks").prev() end, silent = true, desc = "Go to prev mark" },
    { "gmd", function() require("marks").delete_buf() end, silent = true, desc = "Delete marks" },
    { "<leader>M", function() vim.defer_fn(require("marks").toggle, 0) end, silent = true, desc = "Mark Toggle" }
  },
  opts = {
    refresh_interval = 2^14,
    default_mappings = false,
  }
}

-- diff view
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

-- git status signs
Lazy.use {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    trouble = false,
    diff_opts = { indent_heuristic = true },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "[g", function() gs.nav_hunk("prev") end, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "]g", function() gs.nav_hunk("next") end, { buffer = buffer, silent = true, desc = "Next Hunk" })
      vim.keymap.set("n", "gsp", function() gs.nav_hunk("prev") end, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "gsn", function() gs.nav_hunk("next") end, { buffer = buffer, silent = true, desc = "Next Hunk" })
      vim.keymap.set("n", "gsl", function() gs.nav_hunk("last") end, { buffer = buffer, silent = true, desc = "Last Hunk" })
      vim.keymap.set("n", "gsf", function() gs.nav_hunk("first") end, { buffer = buffer, silent = true, desc = "First Hunk" })
      vim.keymap.set("n", "gsR", gs.reset_buffer, { buffer = buffer, silent = true, desc = "Reset Buffer" })
      vim.keymap.set("n", "gsr", gs.reset_hunk, { buffer = buffer, silent = true, desc = "Reset Hunk" })
      vim.keymap.set("n", "gsb", gs.blame_line, { buffer = buffer, silent = true, desc = "Blame Line" })
      vim.keymap.set("n", "gss", gs.stage_hunk, { buffer = buffer, silent = true, desc = "Stage Hunk" })
      vim.keymap.set("n", "gsa", gs.stage_hunk, { buffer = buffer, silent = true, desc = "Stage Hunk" })
      vim.keymap.set("n", "gsv", gs.preview_hunk, { buffer = buffer, silent = true, desc = "Preview Hunk" })
      vim.keymap.set("n", "gsu", gs.undo_stage_hunk, { buffer = buffer, silent = true, desc = "Undo Staged Hunk" })
      vim.keymap.set("n", "gsB", function() gs.blame_line({ full = true }) end, { buffer = buffer, silent = true, desc = "Blame Line Full" })
    end
  }
}

-- statusline
local function show_macro()
  return vim.fn.reg_recording() == "" and "" or "Recording @" .. vim.fn.reg_recording()
end

local function show_lsp_clients()
  return table.concat(vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients({ bufnr = 0 })), " | ")
end

local function show_copilot()
  if not vim.g.loaded_copilot then return "★" end
  if not vim.g.copilot_enabled then return "" end
  return vim.b.copilot_enabled == false and "" or ""
end

-- statusline
Lazy.use {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 512,
  opts = {
    options = {
      theme = Dark.lualine(),
      globalstatus = true,
      icons_enabled = true,
      section_separators = "", -- disable separators
      component_separators = "", -- disable separators
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 3 }, show_macro, "%S" },
      lualine_x = { "selectioncount", "searchcount", show_lsp_clients, show_copilot, "encoding", "fileformat", "filesize", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "%2v:%l/%L" }
    },
    tabline = {
      lualine_a = {{
        "buffers",
        mode = 0, -- shows only buffer name
        icons_enabled = false,
        show_filename_only = true,
        show_modified_status = true,
        hide_filename_extension = false,
        max_length = vim.o.columns, -- maximum width of buffers component
        symbols = { modified = " ^", directory = "", alternate_file = "#" },
        filetype_names = { fzf = "FZF", lazy = "Lazy", noice = "Noice", trouble = "Trouble", NvimTree = "nvim-tree", checkhealth = "check-health" },
      }},
      lualine_y = { { function() return "[ Tab ]" end, color = { fg = Dark.colors.blue } } },
      lualine_z = { "tabs" }
    }
  },
  config = function(_, options)
    local H = require("lualine.highlight")
    local get_mode_suffix = H.get_mode_suffix

    H.get_mode_suffix = function() return
      vim.fn.mode() == "s" and "_select" or get_mode_suffix()
    end

    require("lualine").setup(options)
  end
}

-- fzf
local function vertical(border)
  return {
    preview = {
      layout = "vertical",
      vertical = "down:75%",
      border = border ~= nil and border or "solid"
    }
  }
end

-- fzf
Lazy.use {
  "ibhagwan/fzf-lua",
  -- dir = "~/dev/open-sos/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  cmd = "FzfLua",
  event = is_windows and "VeryLazy" or nil,
  opts = {
    defaults = {
      file_icons = "mini",
      multiprocess = true,
      preview_pager = false,
      file_ignore_patterns = { "package%-lock%.json" }
    },
    fzf_colors = true,
    fzf_opts = {
      ["--cycle"] = "",
      ["--scrollbar"] = "█"
    },
    winopts = {
      row = 0.45,
      col = 0.50,
      width = 0.80,
      height = 0.87,
      border = "solid",
      backdrop = 100,
      preview = {
        default = "builtin",
        border = "solid",
        vertical = "down:50%",
        horizontal = "right:51%",
        scrollbar = "float",
        winopts = { number = false }
      }
    },
    keymap = {
      builtin = {
        ["<C-u>"] = "preview-page-up",
        ["<C-d>"] = "preview-page-down"
      },
      fzf = {
        ["ctrl-u"] = "preview-page-up",
        ["ctrl-d"] = "preview-page-down"
      }
    },
    lsp = {
      winopts = vertical(),
      code_actions = { winopts = vertical() },
    },
    git = {
      tags = { winopts = vertical("border-top") },
      blame = { winopts = vertical("border-top") },
      stash = { winopts = vertical("border-top") },
      status = { winopts = vertical("border-top") },
      commits = { winopts = vertical("border-top") },
      branches = { winopts = vertical("border-top") },
    },
    grep = { winopts = vertical() },
    diagnostics = { winopts = vertical(), multiline = false },
  },
  keys = {
    { "<leader>tt", "<cmd>FzfLua<cr>", silent = true, desc = "FZF Lua" },
    { "<leader>'", "<cmd>FzfLua resume<cr>", silent = true, desc = "FZF Resume" },
    { "<leader>b", "<cmd>FzfLua buffers<cr>", silent = true, desc = "FZF Buffers" },
    { "<leader>j", "<cmd>FzfLua jumps<cr>", silent = true, desc = "FZF Jumps List" },
    { "<leader>h", "<cmd>FzfLua helptags<cr>", silent = true, desc = "FZF Help Tags" },
    { "<leader>m", "<cmd>FzfLua manpages<cr>", silent = true, desc = "FZF Man Pages" },
    { "<leader>g", "<cmd>FzfLua git_status<cr>", silent = true, desc = "FZF Git Status" },
    { "<leader>f", "<cmd>FzfLua files header=false<cr>", silent = true, desc = "FZF Files" },
    { "<leader>/", "<cmd>FzfLua grep_visual<cr>", mode = "v", silent = true, desc = "FZF Search" },
    { "<leader>/", "<cmd>FzfLua live_grep_native<cr>", mode = "n", silent = true, desc = "FZF Search" },
  },
  config = function(_, options)
    require("fzf-lua").setup(options)
    require("fzf-lua").register_ui_select(function(opts)
      local ui_select = { row = 0.25, width = 0.7, height = 0.42 }
      return { winopts = opts.kind == "codeaction" and vertical() or ui_select }
    end)
  end
}

-- diagnostics, references, fzf-lua/telescope results, quickfix and location list
Lazy.use {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  keys = {
    { "<A-t>", "<cmd>Trouble<CR>", silent = true, desc = "Trouble" },
    { "<A-ESC>", "<cmd>Trouble close<CR>", silent = true, desc = "Trouble close" },
    { "<A-F13>", "<cmd>Trouble close<CR>", silent = true, desc = "Trouble close" },
    { "<A-[>", "<cmd>Trouble prev skip_groups=true jump=true<CR>", silent = true, desc = "Trouble prev" },
    { "<A-]>", "<cmd>Trouble next skip_groups=true jump=true<CR>", silent = true, desc = "Trouble next" },
  },
  opts = {
    auto_open = false, -- auto open when there are items
    auto_close = true, -- auto close when there are no items
    auto_preview = true, -- automatically open preview when on an item
    auto_refresh = false, -- auto refresh when open
    auto_jump = true, -- auto jump to the item when there's only one
    focus = false, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = true, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    preview = { border = "none" }, -- override winborder
    modes = {
      lsp_base = { params = { include_current = true } },
      lsp_references = { params = { include_declaration = true } }
    }
  },
  config = function(_, options)
    require("trouble").setup(options)
    require("fzf-lua.config").defaults.actions.files["alt-t"] = require("trouble.sources.fzf").actions.open
  end,
  init = function()
    vim.api.nvim_create_user_command("TroubleFocus", "Trouble focus", { desc = "Trouble Focus" })
    vim.api.nvim_create_user_command("TroubleClose", "Trouble close", { desc = "Trouble Close" })
  end
}

-- shows key bindings in popup
Lazy.use {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = { no_overlap = false },
    delay = function(ctx) return ctx.plugin and 0 or 500 end,
    icons = { rules = false, mappings = false, keys = { BS = "⇠ " } },
    spec = {
      { "gs", group = "Git Signs" },
      { "gm", group = "Go to Mark" },
      { "gb", group = "Go to Buffer" },
      { "sj", mode = { "n", "x" }, desc = "Split/Join" },
      { "<leader>c", group = "Copilot" },
      { "<leader>\\", group = "NvimTree" },
      { "<leader>W", group = "LSP Workspace" },
      { "<leader>?", "<cmd>WhichKey<cr>", desc = "Which Key" },
    },
    triggers = {
      { "<auto>", mode = "nxsot" },
      { "s", mode = { "n", "v", "x" } },
    },
  }
}

-- ui for messages, cmdline, search and popupmenu
Lazy.use {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "muniftanjim/nui.nvim" },
  opts = {
    notify = { view = "mini" },
    messages = { enabled = true },
    popupmenu = { enabled = false },
    cmdline_output = { enabled = true },
    cmdline = { view = "cmdline_popup" },
    commands = { history = { view = "popup" } },
    lsp = {
      hover = { enabled = false },
      message = { enabled = true },
      progress = { enabled = true },
      signature = { enabled = false },
      documentation = { enabled = false }
    },
    format = {
      level = {
        icons = { info = "▪", hint = "★", warn = "◮", error = "" }
      }
    },
    routes = {
      { view = "mini", filter = { event = "msg_showmode" } },
      { view = "popup", filter = { min_height = 7 } },
      { view = "popup", filter = { event = "msg_show", min_height = 7 } },
      { view = "split", filter = { cmdline = "^:", min_height = 7 } },
      { filter = { event = "lsp", kind = "progress", find = "GitHub Copilot", min_length = 17, max_length = 17 }, opts = { skip = true } },
    },
    views = {
      split = { size = "24%" },
      notify = { merge = true, replace = true },
      messages = { view = "popup", enter = true },
      confirm = { position = { row = 5, col = "50%" } },
      popup = {
        size = { width = "78%", height = "60%" },
        border = { style = "rounded", padding = { 0, 1 } },
        win_options = { wrap = true }
      },
      cmdline_input = {
        border = { style = "solid", padding = { 0, 1 } },
        win_options = { winhighlight = { Normal = "NoiceDark" } }
      },
      cmdline_popup = {
        align = "center",
        position = { row = 8, col = "50%" },
        size = { min_width = 82, max_width = 120 },
        border = { style = "solid", padding = { 0, 1 } },
        win_options = { winhighlight = { Normal = "NoiceDark" } }
      },
      mini = {
        timeout = 2800,
        border = { style = "solid", padding = { 1, 2 } },
        position = { row = 3, col = "98%" },
        win_options = { winhighlight = { Normal = "MiniNotifyNormal" } }
      }
    }
  },
  config = function(_, options)
    require("noice").setup(options)
    require("noice.config.format").builtin.lsp_progress_done[1] = { " ", hl_group = "NoiceLspProgressSpinner" }

    _G.d = function(...) vim.notify(vim.inspect(...), vim.log.levels.DEBUG) end
    vim.keymap.set({ "c" }, "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()); vim.api.nvim_input("<esc>") end)
  end
}

-- tree-sitter
-- nvim --headless +"Lazy load nvim-treesitter" +TSUpdateSync +qa!
-- nvim --headless +"Lazy load nvim-treesitter" +"TSInstallSync! all" +qa!
-- nvim --headless +"Lazy load nvim-treesitter" +"TSInstallFromGrammar! all" +qa!
Lazy.use {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = "all",
    ignore_install = { "bp", "just", "norg", "foam", "hoon", "rnoweb", "gdshader" },
    indent = {
      enable = true, -- indentation for = operator
      disable = { "html" } -- disable for html filetype
    },
    playground = { enable = false }, -- Inspect/TSHighlightCapturesUnderCursor
    highlight = {
      enable = true, -- false will disable the extension
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100kb
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false -- setting this to true will run syntax and tree-sitter at the same time
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        node_decremental = "<bs>",
        scope_incremental = false,
      }
    }
  },
  config = function(_, options)
    -- require("nvim-treesitter.install").compilers = { "cc", "gcc", "clang", "cl", "zig" }
    require("nvim-treesitter.install").prefer_git = false
    require("nvim-treesitter.configs").setup(options)
  end
}

-- arround/inside text objects
-- text-objects move to class/function/method
Lazy.use {
  "echasnovski/mini.ai",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-textobjects" }
  },
  keys = {
    { "a", mode = { "x", "o" } },
    { "i", mode = { "x", "o" } },
    { "[[", desc = "Prev start @class" },
    { "]]", desc = "Next start @class" },
    { "[]", desc = "Prev end @class" },
    { "][", desc = "Next end @class" },
    { "[f", desc = "Prev start @function" },
    { "]f", desc = "Next start @function" },
    { "[F", desc = "Prev end @function" },
    { "]F", desc = "Next end @function" },
  },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 420,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      },
    }
  end,
  config = function(_, options)
    require("mini.ai").setup(options)
    --- @diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start     = { ["]]"] = "@class.outer", ["]f"] = "@function.outer" },
          goto_next_end       = { ["]["] = "@class.outer", ["]F"] = "@function.outer" },
          goto_previous_start = { ["[["] = "@class.outer", ["[f"] = "@function.outer" },
          goto_previous_end   = { ["[]"] = "@class.outer", ["[F"] = "@function.outer" },
        }
      }
    })
  end
}

------------------------------------------------------------
-- Copilot
------------------------------------------------------------

local Copilot = {
  word_term = vim.api.nvim_replace_termcodes("<Plug>(copilot-accept-word)", true, true, true),
  line_term = vim.api.nvim_replace_termcodes("<Plug>(copilot-accept-line)", true, true, true),
}

Copilot.enable = function()
  vim.cmd("Copilot enable")
  vim.g.copilot_enabled = true
  vim.notify("Copilot: Enabled")
end

Copilot.disable = function()
  vim.cmd("Copilot disable")
  vim.g.copilot_enabled = false
  vim.notify("Copilot: Disabled")
end

Copilot.toggle = function()
  if vim.g.copilot_enabled then
    Copilot.disable()
    Copilot.buf_disable()
  else
    Copilot.enable()
    Copilot.buf_enable()
  end
end

Copilot.buf_enable = function()
  if vim.g.copilot_enabled then
    vim.b.copilot_enabled = true
    -- vim.cmd[[silent! call copilot#Suggest()]]
  end
end

Copilot.buf_disable = function()
  vim.b.copilot_enabled = false
  vim.cmd[[silent! call copilot#Dismiss()]]
end

Copilot.accept_word = function()
  vim.b.completion = false
  vim.api.nvim_feedkeys(Copilot.word_term, "i", true)
  vim.schedule(function() vim.b.completion = true end)
end

Copilot.accept_line = function()
  vim.b.completion = false
  vim.api.nvim_feedkeys(Copilot.line_term, "i", true)
  vim.schedule(function() vim.b.completion = true end)
end

Copilot.is_active = function()
  local suggestion = vim.fn["copilot#GetDisplayedSuggestion"]()
  return suggestion ~= nil and suggestion.text ~= nil and suggestion.text ~= ""
end

Copilot.is_enabled = function()
  return vim.g.loaded_copilot and vim.g.copilot_enabled ~= false and vim.b.copilot_enabled ~= false
end

Lazy.use {
  "github/copilot.vim",
  cmd = "Copilot",
  keys = {
    { "<leader>ct", Copilot.toggle, silent = true, desc = "[] Copilot Enable/Disable" },
    { "<leader>cp", "<cmd>Copilot panel<CR>", mode = { "n", "v" }, silent = true, desc = "[] Copilot Panel [10]" },
    { "<leader>cs", "<cmd>Copilot status<CR>", mode = { "n", "v" }, silent = true, desc = "[] Copilot Start/Status" },
  },
  config = function()
    vim.keymap.set("i", "<A-t>", Copilot.toggle, { silent = true, desc = "Copilot Toggle"})
    vim.keymap.set("i", "<A-f>", Copilot.accept_word, { silent = true, desc = "Copilot Accept Word" })
    vim.keymap.set("i", "<C-e>", Copilot.accept_line, { silent = true, desc = "Copilot Accept Line" })
    vim.keymap.set("i", "<A-]>", "<Plug>(copilot-next)", { silent = true, desc = "Copilot Next" })
    vim.keymap.set("i", "<A-[>", "<Plug>(copilot-previous)", { silent = true, desc = "Copilot Prev" })
    vim.keymap.set("i", "<A-ESC>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot Dismiss" })
    vim.keymap.set("i", "<A-F13>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot Dismiss" })
    vim.keymap.set("i", "<A-\\>", "<Plug>(copilot-suggest)", { silent = true, desc = "Copilot Request Suggestion" })
    vim.keymap.set("i", "<A-CR>", "copilot#Accept('<CR>')", { expr = true, replace_keycodes = false, silent = true, desc = "Copilot Accept" })
  end,
  init = function()
    vim.g.copilot_enabled = true
    vim.g.copilot_no_tab_map = true
    vim.cmd[[autocmd FileType copilot setlocal norelativenumber]]
    vim.api.nvim_create_autocmd("User", { pattern = "BlinkCmpMenuOpen", callback = Copilot.buf_disable })
    vim.api.nvim_create_autocmd("User", { pattern = "BlinkCmpMenuClose", callback = Copilot.buf_enable })
  end
}

------------------------------------------------------------
-- olimorris/codecompanion.nvim
------------------------------------------------------------

Lazy.use {
  "olimorris/codecompanion.nvim",
  -- dir = "~/dev/open-sos/codecompanion.nvim",
  dependencies = { "github/copilot.vim", "echasnovski/mini.diff", "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    { "<leader>cq", mode = { "n", "v" }, "<cmd>CodeCompanion<cr>", silent = true, desc = "CodeCompanion AI Prompt" },
    { "<leader>ca", mode = { "n", "v" }, "<cmd>CodeCompanionActions<cr>", silent = true, desc = "CodeCompanion Actions" },
    { "<leader>cc", mode = { "n", "v" }, "<cmd>CodeCompanionChat Toggle<cr>", silent = true, desc = "CodeCompanion Chat Toggle" },
  },
  opts = {
    adapters = {
      copilot_gpt4o = function() return require("codecompanion.adapters").extend("copilot", { schema = { model = { default = "gpt-4o" } } }) end,
      copilot_gpt41 = function() return require("codecompanion.adapters").extend("copilot", { schema = { model = { default = "gpt-4.1" } } }) end,
    },
    strategies = {
      inline = {
        adapter = "copilot",
        keymaps = {
          accept_change = { modes = { n = "<C-a>", x = "<C-a>" } },
          reject_change = { modes = { n = "<C-r>", x = "<C-r>" } },
        }
      },
      chat = {
        adapter = "copilot_gpt41",
        keymaps = {
          send = { modes = { n = "<CR>", i = "<C-CR>" } },
          close = { modes = { n = "<C-q>", i = "<C-q>" } },
        }
      }
    },
    display = {
      -- inline = { layout = "buffer" },
      diff = {
        provider = "mini_diff"
      },
      chat = {
        show_settings = true,
        show_header_separator = true,
        window = {
          opts = {
            signcolumn = "yes",
            relativenumber = false
          }
        }
      },
      action_palette = {
        prompt = "[AI] Prompt",
        provider = "default", -- default is working with fzf_lua vertical layout
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
        }
      }
    }
  }
}

------------------------------------------------------------
-- LSP - setup
-- neovim/nvim-lspconfig
------------------------------------------------------------
local LSP = {}

--- @type table<string, vim.lsp.Config>
LSP.servers = {
  cssls = {},
  taplo = {},
  bashls = {},
  jsonls = {},
  yamlls = {},
  dockerls = {},
}

LSP.servers["html"] = {
  filetypes = { "html", "cshtml", "razor", "htmlangular" }
}

LSP.servers["emmet_language_server"] = {
  filetypes = { "html", "cshtml", "razor", "htmlangular" }
}

LSP.servers["angularls"] = {
  filetypes = { "html", "htmlangular" },
  root_markers = { "angular.json" },
  workspace_required = true
}

LSP.servers["lua_ls"] = {
  settings = {
    Lua = {
      format = { enable = true },
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      completion = { callSnippet = "Replace" },
      workspace = { checkThirdParty = "Disable" }
    }
  }
}

LSP.servers["powershell_es"] = {
  bundle_path = is_windows and "C:/dev/ps-es-lsp" or "/opt/powershell-editor-services"
}

LSP.servers["azure_pipelines_ls"] = {
  filetypes = { "yaml" },
  root_markers = { "azure/", "pipelines/" },
  workspace_required = true,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "azure*.yml",
          "azure/*.yml",
          "*pipeline.yml",
          "pipelines/*.yml",
        }
      }
    }
  }
}

------------------------------------------------------------
-- LSP - setup listed servers
------------------------------------------------------------

LSP.setup_servers = function()
  vim.lsp.config("*", {
    capabilities = LSP.capabilities()
  })

  for server, options in pairs(LSP.servers) do
    vim.lsp.config(server, options or {})
    vim.lsp.enable(server)
  end
end

------------------------------------------------------------
-- LSP - client capabilities
------------------------------------------------------------

LSP.capabilities = function()
  -- client capabilities
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()

  -- additional capabilities
  local blink_lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

  -- @perf: didChangeWatchedFiles is too slow
  -- @todo: Remove this when https://www.github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed
  local workarround_perf_fix = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    }
  }

  local capabilities = vim.tbl_deep_extend("force", {}, client_capabilities, blink_lsp_capabilities, workarround_perf_fix)

  return capabilities
end

------------------------------------------------------------
-- LSP - attach keymaps on LspAttach event
------------------------------------------------------------

LSP.keymaps = function()
  LSP.del_keymaps()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      LSP.buffer_keymaps(event.buf)
    end
  })
end

------------------------------------------------------------
-- LSP buffer keymaps
------------------------------------------------------------

-- delete defaults
LSP.del_keymaps = function()
  local function safe_del_keymap(mode, lhs)
    if vim.fn.mapcheck(lhs, mode) ~= "" then
      vim.keymap.del(mode, lhs)
    end
  end

  safe_del_keymap("n", "gra") -- actions
  safe_del_keymap("x", "gra") -- actions
  safe_del_keymap("n", "grn") -- rename
  safe_del_keymap("n", "grr") -- references
  safe_del_keymap("n", "gri") -- implementations
end

-- set mappings
LSP.buffer_keymaps = function(buffer)
  -- enable completion triggered by <c-x><c-o>
  vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- key map fn
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = buffer, desc = desc, nowait = true })
  end

  -- vim.lsp.buf.references - default is <grr>
  keymap("n", "gr", "<cmd>FzfLua lsp_references<cr>", "LSP References")
  keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", "LSP References")

  -- vim.lsp.buf.definition
  keymap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "LSP Definition")

  -- vim.lsp.buf.declaration
  keymap("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "LSP Declaration")

  -- vim.lsp.buf.implementation - default is <gri>
  keymap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "LSP Implementation")

  -- vim.lsp.buf.type_definition
  keymap("n", "g<space>", "<cmd>FzfLua lsp_typedefs<cr>", "LSP Type Definition")

  -- default is <grn>
  keymap({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, "LSP Rename")

  -- vim.lsp.buf.format with async = true
  keymap({ "n", "v" }, "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format")

  -- default is <K>
  -- keymap({ "n", "v" }, "K", vim.lsp.buf.hover, "LSP Hover")
  keymap({ "n", "v" }, "<leader>k", vim.lsp.buf.hover, "LSP Hover")

  -- default is <CTRL-s> in insert mode
  keymap({ "n", "v" }, "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")
  keymap({ "n", "v", "i" }, "<C-s>", vim.lsp.buf.signature_help, "LSP Signature Help")

  -- default is <gra>
  keymap({ "n", "v" }, "<leader>A", vim.lsp.buf.code_action, "LSP Code Action") -- with preview
  keymap({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions previewer=false winopts.row=0.25 winopts.width=0.7 winopts.height=0.42<cr>", "LSP Code Action") -- no preview

  -- toggle inlay hints
  keymap("n", "<leader>;", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, "LSP Toggle Inlay Hints")

  -- toggle view diagnostics
  keymap("n", "<leader>,", function()
    local c = vim.diagnostic.config()
    vim.diagnostic.config({
      virtual_text = not c.virtual_text and { current_line = true } or false,
      virtual_lines = not c.virtual_lines and { current_line = true } or false
    })
  end, "LSP Toggle diagnostics")

  -- diagnostics <CTRL-W-d> is default
  keymap("n", "<leader>E", vim.diagnostic.open_float, "LSP Diagnostic Float")
  keymap("n", "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", "LSP Document Diagnostics")
  keymap("n", "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", "LSP Workspace Diagnostics")

  -- workspace
  keymap("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, "LSP Add Workspace Folder")
  keymap("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, "LSP Remove Workspace Folder")
  keymap("n", "<leader>Wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP Workspace List Folders")
end

------------------------------------------------------------
-- LSP - navigation through method overloads
------------------------------------------------------------

LSP.overloads = function()
  local function show_lsp_signature_overloads()
    require("blink.cmp.signature.trigger").hide()
    vim.cmd("LspOverloadsSignature");
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfigOverload", {}),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client ~= nil and client.server_capabilities.signatureHelpProvider then
        require("lsp-overloads").setup(client, {
          silent = true,
          display_automatically = false,
          ui = { silent = true, border = win_border }, --- @diagnostic disable-line
          keymaps = { next_signature = "<A-n>", previous_signature = "<A-p>", close_signature = "<A-o>" } --- @diagnostic disable-line
        })

        vim.keymap.set({ "n", "i" }, "<A-o>", show_lsp_signature_overloads, { silent = true, desc = "LSP Overloads" });
      end
    end
  })
end

------------------------------------------------------------
-- LSP init settings and servers
-- NOTE -- vim.lsp.document_color.enable() -- nvim v0.12
------------------------------------------------------------

LSP.init = function()
  LSP.keymaps()
  LSP.overloads()
  LSP.setup_servers()
end

------------------------------------------------------------
-- LSP setup
------------------------------------------------------------
Lazy.use {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  dependencies = {
    { "saghen/blink.cmp" }, -- LSP AutoComplete
    { "issafalcon/lsp-overloads.nvim" }, -- Extends native nvim-lsp handlers to allow easier navigation through method overloads
  },
  config = function()
    LSP.init()
  end
}

-- LuaLS setup for Neovim init.lua
Lazy.use {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "lazy.nvim", words = { "Lazy" } },
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
    integrations = {
      cmp = false,
      lspconfig = true,
    }
  }
}

-- LSP Rust will setup rust-analyzer
Lazy.use {
  "mrcjkb/rustaceanvim",
  ft = "rust",
  version = "*",
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          relative = "cursor",
        }
      },
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            inlayHints = {
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              }
            }
          }
        },
        on_attach = function(_, bufnr)
          LSP.keymaps()
          vim.keymap.set("n", "<leader>C", function() vim.cmd.RustLsp("flyCheck") end, { silent = true, buffer = bufnr, desc = "LSP Run Clippy" })
          vim.keymap.set("n", "<leader>E", function() vim.cmd.RustLsp("explainError") end, { silent = true, buffer = bufnr, desc = "LSP Explain Error" })
        end
      },
    }
  end
}

-- LSP TypeScript TS Server
Lazy.use {
  "pmizio/typescript-tools.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
  event = { "BufReadPre *.ts,*.tsx,*.js,*.jsx,*.mjs", "BufNewFile *.ts,*.tsx,*.js,*.jsx,*.mjs" },
  opts = {
    -- capabilities = LSP.capabilities(),
    settings = {
      -- locale of all tsserver messages
      tsserver_locale = "en",

      -- memory limit in megabytes or "auto" - basically no limit
      tsserver_max_memory = "auto",

      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,

      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",

      -- fn completion
      complete_function_calls = true,
      include_completions_with_insert_text = true,

      -- specify commands exposed as code_actions
      expose_as_code_action = "all",

      -- ts preferences
      tsserver_file_preferences = {
        quotePreference = "auto",
        includeInlayVariableTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayFunctionLikeReturnTypeHints = true,
      }
    }
  }
}

------------------------------------------------------------
-- DB
------------------------------------------------------------
Lazy.use {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } }
  },
  cmd = { "DBUI", "DBUIToggle" },
  keys = {{ [[<leader>\d]], "<cmd>DBUIToggle<cr>", silent = true, desc = "DBUI Toggle" }},
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1
    -- vim.cmd[[autocmd FileType dbout setlocal nofoldenable foldmethod=manual]]
  end
}

------------------------------------------------------------
-- AutoComplete -- https://cmp.saghen.dev/
------------------------------------------------------------
Lazy.use {
  "saghen/blink.cmp",
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },

  --- @module "blink.cmp"
  --- @type blink.cmp.Config
  opts = {
    term = { enabled = false },
    signature = { enabled = true },

    sources = {
      default = { "lsp", "path", "buffer" },
      per_filetype = {
        sql = { "dadbod", "buffer" },
        codecompanion = { "codecompanion" },
      },
      providers = {
        lsp = {
          name = "LSP",
          fallbacks = {},
          score_offset = 1024,
          should_show_items = function(_, items)
            -- remove always suggested closing tag by html server
            return not (#items == 1 and vim.tbl_contains({ "html", "razor", "cshtml", "htmlangular" }, vim.bo.filetype) and vim.startswith(items[1].label, "</"))
          end,
          transform_items = function(_, items)
            -- filter out text items and html closing tags
            return vim.tbl_filter(function(item) return item.kind ~= 1 and not vim.startswith(item.label, "</") end, items)
          end,
        },
        path = { max_items = 10, score_offset = 512 },
        buffer = { max_items = 10, score_offset = 256 },
        snippets = { max_items = 128, score_offset = 128 },
        dadbod = { module = "vim_dadbod_completion.blink", fallbacks = { "buffer", "snippets" } }
      },
      min_keyword_length = function()
        return vim.tbl_contains({ "html", "razor", "cshtml", "htmlangular", "markdown" }, vim.bo.filetype) and 1 or 0
      end
    },

    completion = {
      menu = {
        max_height = 18,
        draw = { align_to = "none" },
        auto_show = function(context, items) return not (Copilot.is_enabled() and Copilot.is_active()) end
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = true
        }
      },
      accept = {
        auto_brackets = {
          enabled = true
        }
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 256,
        update_delay_ms = 128,
        window = {
          min_width = 64,
          max_width = 128,
          max_height = 32,
          desired_min_width = 64,
        }
      },
      keyword = { range = "prefix" },
      ghost_text = {
        enabled = function() return not (Copilot.is_enabled() and Copilot.is_active()) end
      }
    },

    keymap = {
      preset = "none",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "select_and_accept", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<C-a>"] = { "hide", "fallback" },
      ["<C-c>"] = { "cancel", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<A-n>"] = { "select_next", "fallback" },
      ["<A-p>"] = { "select_prev", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-space>"] = { "show", "hide", --[[ "show_documentation", "hide_documentation" ]] },
      ["<C-S-space>"] = { function(cmp) cmp.show({ providers = { "snippets" } }) end, "hide" },
    },

    cmdline = {
      enabled = true,
      completion = {
        menu = { auto_show = false },
        ghost_text = { enabled = true },
      },
      keymap = {
        preset = "none",
        ["<C-e>"] = { "select_and_accept", "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<C-a>"] = { "cancel", "fallback_to_mappings" },
        ["<C-c>"] = { "cancel", "fallback", "fallback_to_mappings" },
        ["<C-w>"] = { "cancel", "fallback", "fallback_to_mappings" },
        ["<C-n>"] = { "show_and_insert", "select_next", "fallback" },
        ["<C-p>"] = { "show_and_insert", "select_prev", "fallback" },
        ["<Tab>"] = { "show_and_insert", "select_next", "fallback" },
        ["<S-Tab>"] = { "show_and_insert", "select_prev", "fallback" },
        ["<C-space>"] = { "show", "hide", "fallback" },
      }
    }
  },

  opts_extend = { "sources.default" }
}

------------------------------------------------------------
-- Lazy init
------------------------------------------------------------

-- install lazy plugin manager
Lazy.install()

-- install all configured plugins
Lazy.setup()

------------------------------------------------------------
-- Map <C-q>
-- smart close tabs and buffers
------------------------------------------------------------

-- check if window is user valid window
local is_valid_window = function(window_handle)
  if not vim.api.nvim_win_is_valid(window_handle) then
    return false
  end
  local config = vim.api.nvim_win_get_config(window_handle)
  return config.relative == "" and config.focusable ~= false
end

-- smart close
local function smart_close()
  local listed_buffs = vim.fn.getbufinfo({ buflisted = 1 })
  local windows_count = #vim.tbl_filter(is_valid_window, vim.api.nvim_tabpage_list_wins(0))

  if vim.bo.modified then
    return vim.notify("Buffer has unsaved changes!")
  end

  if vim.bo.filetype == "help" then
    return vim.cmd("helpclose")
  end

  if vim.fn.getcmdwintype() ~= "" then
    return vim.cmd("quit")
  end

  if vim.bo.buftype == "terminal" then
    return vim.cmd("bdelete!")
  end

  if #listed_buffs > 1 then
    return vim.cmd("bdelete")
  end

  if windows_count > 1 then
    return vim.cmd("close")
  end

  if vim.fn.tabpagenr("$") > 1 then
    return vim.cmd("tabclose")
  end

  vim.notify("Cannot close last tab or buffer!")
end

-- set keymap
vim.keymap.set("n", "<C-q>", smart_close, { silent = true, desc = "Close buffer if not last" })

------------------------------------------------------------
-- Map <esc>
-- Map <F1> to <ESC>
-- close all floating windows
-- close quickfix list, location list, trouble & noice
------------------------------------------------------------

vim.cmd("map <F1> <esc>")
vim.cmd("map! <F1> <esc>")

-- close quickfix/location list
local function close_qf_loc_list()
  -- Check if the quickfix list is open
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
  end
  -- Check if the location list is open
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd("lclose")
  end
end

-- escape fn
local function escape()
  close_qf_loc_list()

  vim.cmd("Noice dismiss")
  vim.cmd("silent! fclose!")

  if vim.snippet.active() then
    vim.snippet.stop()
  end

  if MiniMap ~= nil then MiniMap.open() end
  if MiniJump ~= nil and MiniJump.state.jumping then MiniJump.stop_jumping() end
end

-- map <esc> key
vim.keymap.set("n", "<esc>", escape, { silent = true, noremap = true, desc = "Escape" })

------------------------------------------------------------
-- NeoVide
------------------------------------------------------------

if vim.g.neovide then
  vim.g.neovide_remember_window_size = true

  -- intel one mono
  vim.opt.linespace = is_wsl_or_windows and 2 or 1

  -- jet brains mono
  -- vim.opt.linespace = is_wsl_or_windows and 2 or 3

  -- fzf-lua paste fix
  vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end, { noremap = true, silent = true })
end

--------------------------------------------------------------------------------
-- Troubleshoot
--------------------------------------------------------------------------------

-- :Rust
-- :LspInfo
-- :checkhealth
-- :set filetype?
-- :set cmdheight=2
-- :set completeopt?
-- :verbose imap <tab>
-- :verbose set completeopt?

--------------------------------------------------------------------------------
-- Required in path
--------------------------------------------------------------------------------

-- html, css, json, eslint!
-- npm i -g vscode-langservers-extracted
-- pacman -S vscode-css-languageserver
-- pacman -S vscode-html-languageserver
-- pacman -S vscode-json-languageserver

-- npm i -g emmet-ls [ issues/outdated ]
-- npm i -g @olrtg/emmet-language-server

-- npm i -g @angular/language-server
-- angularls needs "@angular/language-service" locally installed per project

-- npm i -g bash-language-server
-- pacman -S bash-language-server

-- npm i -g azure-pipelines-language-server
-- npm i -g dockerfile-language-server-nodejs

-- use with typescript-tools lua plugin!
-- npm i -g typescript typescript-language-server
-- pacman -S typescript typescript-language-server

-- pacman -S zig zls
-- pacman -S gcc clang
-- pacman -S taplo taplo-cli
-- pacman -S rust rust-analyzer
-- pacman -S lua-language-server
-- pacman -S yaml-language-server

-- pacman -S [AUR] shellcheck-bin
-- pacman -S [AUR] powershell-bin powershell-editor-services

-- pacman -S tree-sitter tree-sitter-cli
-- pacman -S fd ripgrep curl nodejs tree-sitter ttf-nerd-fonts-symbols-mono

--------------------------------------------------------------------------------
-- Roslyn
--------------------------------------------------------------------------------

-- bin/roslyn-update.sh
-- Download `Microsoft.CodeAnalysis.LanguageServer.linux-x64` from
-- https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl
-- Extract <zip-root>/content/LanguageServer/<yourArch> and move to:
-- Linux: ~/.local/share/nvim/roslyn
-- Windows: %LOCALAPPDATA%\nvim-data\roslyn
-- Verify with `dotnet Microsoft.CodeAnalysis.LanguageServer.dll --version`

--------------------------------------------------------------------------------
-- LSP server configurations
--------------------------------------------------------------------------------
-- https://github.com/neovim/nvim-lspconfig
--------------------------------------------------------------------------------
