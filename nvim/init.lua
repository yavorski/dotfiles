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

-- syntax highlighting
vim.opt.syntax = "enable"

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

-- highlight current line
vim.opt.cursorline = true

-- enable folding (default "foldmarker")
vim.opt.foldmethod = "marker"

-- intro / messages / hit-enter prompts / ins-completion-menu
vim.opt.shortmess = "actIsoOFW"

-- line lenght marker
-- vim.opt.colorcolumn = "128"

-- signcolumn
vim.opt.signcolumn = "auto"

-- enable mouse
vim.opt.mouse = "a"

-- min number of screen lines above/below the cursor
vim.opt.scrolloff = 4

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

-- complete menu
vim.opt.completeopt = "menu,menuone,noselect"

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
-- Reset "expandtab" in order to use "hard tabs"
------------------------------------------------------------

-- rust enable tabs and user settings
-- vim.g.rust_recommended_style = 0

-- enable tabs for the following filetypes
vim.cmd[[autocmd FileType make setlocal noexpandtab]]
-- vim.cmd[[autocmd FileType ps1 setlocal noexpandtab]]
-- vim.cmd[[autocmd FileType rust setlocal noexpandtab]]

------------------------------------------------------------
-- list
------------------------------------------------------------
vim.opt.list = false
vim.opt.listchars = { space = "·", eol = " ", tab = "» ", trail = "~" }

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
-- sysname
------------------------------------------------------------

local sysname = vim.loop.os_uname().sysname
local is_linux = sysname == "Linux"
local is_windows = sysname == "Windows_NT"

------------------------------------------------------------
-- Filetypes Auto Detection
------------------------------------------------------------

vim.filetype.add({
  pattern = {
    [ ".*/waybar/config" ] = "jsonc",
    [ ".*/ghostty/config" ] = "conf",
    [ ".*/hypr/.*%.conf" ] = "hyprlang",
  }
})

------------------------------------------------------------
-- edit cmd
------------------------------------------------------------

-- enable all filetype plugins
-- vim.cmd[[filetype plugin indent on]]

-- trim trailing whitespace on save
-- vim.cmd[[autocmd BufWritePre * :%s/\s\+$//e]]

local tws_autocmd_id = vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[:%s/\s\+$//e]]
})

-- treat json files as jsonc
-- vim.cmd[[autocmd BufEnter *.json set filetype=jsonc]]

-- disable relative numbers
vim.cmd[[autocmd FileType qf,lhelp,lquickfix setlocal norelativenumber]]

-- don't auto comment new lines
vim.cmd[[autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o]]

-- highlight on yank
vim.cmd[[autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup = "YankHighlight" })]]

-- 2 spaces for selected filetypes
-- vim.cmd[[autocmd FileType xml,html,xhtml,css,scss,javascript,json,lua,yaml setlocal shiftwidth=2 tabstop=2]]

-- Normalize Line Endings
-- HACK to detect visual mode
-- https://www.petergundel.de/neovim/lua/hack/2023/12/17/get-neovim-mode-when-executing-a-command.html
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
  local is_gitsigns_loaded = pcall(require, "gitsigns")

  if is_gitsigns_loaded then
    vim.cmd("Gitsigns detach")
  end

  vim.cmd("set fileformat=unix")
  normalize_line_endings(options)

  if is_gitsigns_loaded then
    vim.cmd("Gitsigns attach")
  end

  vim.api.nvim_win_set_cursor(0, cursor_position)
end

-- user command
vim.api.nvim_create_user_command("ForceLF", forcelf, { nargs = "?", range = "%", addr = "lines", desc = "Set LF Line Endings" })

------------------------------------------------------------
-- Buffer Only CMD
------------------------------------------------------------

local function buffer_only(discard_modified_buffers)
  vim.cmd("silent! tabonly!")

  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_buffer_filetype = vim.api.nvim_get_option_value("filetype", { buf = current_buffer })

  if current_buffer_filetype == "NvimTree" then
    return vim.api.nvim_notify("NvimTree", vim.log.levels.INFO, {})
  end

  for _, buffer in ipairs(buffers) do
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
    local stopper = buffer == current_buffer or ft == "minimap" or ft == "NvimTree" or not vim.api.nvim_buf_is_valid(buffer)

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
-- Keymaps
------------------------------------------------------------

-- disable built in |m| key - marks operations
vim.keymap.set({ "n", "v", "x" }, "m", "<Nop>", { silent = true })

-- disable built in |s| key - deletes char under cursor
-- vim.keymap.set({ "n", "v", "x" }, "s", "<Nop>", { silent = true })

-- match brackets remap
-- vim.keymap.set({ "n", "v", "x" }, "mm", "%", { silent = true })
vim.keymap.set("n", "mm", "<Plug>(MatchitNormalForward)", { silent = true })
vim.keymap.set({ "v", "x" }, "mm", "<Plug>(MatchitVisualForward)", { silent = true })

-- comment - additional keymaps
vim.api.nvim_set_keymap("v", "<C-c>", "gc", { silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", "gcc", { silent = true })

-- copy/paste system clipboard
vim.keymap.set("n" , "<leader>%y", "<cmd>silent! %y+<cr>", { silent = true, desc = "[sc] Yank Buffer" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { silent = true, desc = "[sc] Yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>Y", [["+yy]], { silent = true, desc = "[sc] Yank Line" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", [["+p]], { silent = true, desc = "[sc] Paste After" })
vim.keymap.set({ "n", "v", "x" }, "<leader>P", [["+P]], { silent = true, desc = "[sc] Paste Before" })

-- buffer navigation -standard prev/next
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { silent = true })
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
  colors = {
    none      = "NONE",
    rosewater = "#f5e0dc", -- Winbar
    flamingo  = "#f2cdcd", -- Target word
    pink      = "#ff1493", -- [!] Just pink
    mauve     = "#c678dd", -- [!] Tag
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
    text      = "#cdd6f4", -- Default fg
    subtext1  = "#bac2de", -- Indicator
    subtext0  = "#a6adc8", -- Float title
    overlay2  = "#9399b2", -- Popup fg
    overlay1  = "#7f849c", -- Conceal color
    overlay0  = "#6c7086", -- Fold color
    surface2  = "#585b70", -- Default comment
    surface1  = "#45475a", -- Darker comment
    surface0  = "#313244", -- Darkest comment
    trick     = "#1abc9c", -- [*] Trick
    stealth   = "#14ff80", -- [*] Type
    skyblue   = "#54b9f7", -- [*] Sky blue
    mantle    = "#181825", -- [!] Dark 6
    coal      = "#161622", -- [*] Dark 5
    base      = "#14141f", -- [!] Dark 4 - Default BG
    crust     = "#11111b", -- [!] Dark 3
    dusk      = "#0f0f17", -- [*] Dark 2
    dark      = "#0a0a0f", -- [*] Dark 1
    black     = "#000000", -- [*] Dark 0 -- Just Black
  }
}

function Dark.editor(colors)
  local O = require("catppuccin").options
  local mocha = require("catppuccin.palettes.mocha")

  return {
    -- nvim
    LineNr = { bg = colors.mantle },
    VertSplit = { fg = colors.crust, bg = colors.crust },
    CursorLine = { bg = O.transparent_background and colors.black or colors.crust },

    FoldColumn = { bg = colors.mantle },
    SignColumn = { bg = colors.mantle },
    SignColumnSB = { bg = colors.mantle },

    MsgArea = { bg = colors.dusk },
    FloatBorder = { fg = colors.blue, bg = colors.base }, -- Border for floating windows
    NormalFloat = { bg = (O.transparent_background and vim.o.winblend == 0) and colors.none or colors.base }, -- Floating windows
    WinSeparator = { fg = colors.dusk, bg = colors.dusk }, -- Splits separator

    Pmenu = { bg = colors.crust },
    PmenuSbar = { bg = colors.mantle },
    PmenuThumb = { bg = colors.teal },

    Search = { fg = colors.base, bg = mocha.yellow },
    IncSearch = { fg = colors.base, bg = mocha.mauve },
    CurSearch = { fg = colors.base, bg = mocha.red },
    YankHighlight = { fg = colors.base, bg = mocha.green },

    -- nvim mini
    MiniTrailspace = { bg = colors.red },
    MiniMapSymbolView = { fg = colors.red },
    MiniIndentscopeSymbol = { fg = colors.red },
    MiniNotifyNormal = { bg = colors.dark },
    MiniNotifyBorder = { fg = colors.dark, bg = colors.dark },

    -- nvim marks
    MarkSignHL = { bg = colors.mantle },
    MarkSignNumHL = { bg = colors.mantle },

    -- nvim tree
    NvimTreeNormal = { bg = O.transparent_background and colors.none or colors.base },
    NvimTreeCursorLine = { bg = colors.dark },
    NvimTreeRootFolder = { fg = colors.peach },
    NvimTreeWinSeparator = { fg = colors.crust, bg = colors.crust },
    NvimTreeFolderName = { fg = colors.skyblue },
    NvimTreeFolderIcon = { fg = colors.skyblue },

    -- nvim gitsigns
    GitSignsAdd = { fg = colors.green, bg = colors.mantle },
    GitSignsChange = { fg = colors.yellow, bg = colors.mantle },
    GitSignsDelete = { fg = colors.red, bg = colors.mantle },

    -- which key
    WhichKey = { bg = colors.crust },
    WhichKeyNormal = { bg = colors.crust },

    -- trouble
    TroubleNormal = { bg = colors.mantle },
    TroubleNormalNC = { bg = colors.mantle },
    TroublePos = { fg = colors.subtext1, bg = colors.none },
    TroubleCount = { fg = colors.green, bg = colors.none },

    -- nvim fzf-lua
    FzfLuaNormal = { fg = colors.text, bg = colors.mantle },
    FzfLuaBorder = { fg = colors.mantle, bg = colors.mantle },
    FzfLuaCursorLine = { bg = colors.black },

    FzfLuaPreviewNormal = { bg = colors.crust },
    FzfLuaPreviewBorder = { fg = colors.crust, bg = colors.crust },
    FzfLuaPreviewTitle = { fg = colors.blue, bg = colors.black },

    FzfLuaScrollFloatFull  = { bg = colors.peach },
    FzfLuaScrollFloatEmpty = { link = "NormalFloat" },
    FzfLuaScrollBorderFull = { fg = colors.peach, bg = colors.peach },
    FzfLuaScrollBorderEmpty = { fg = colors.mantle, bg = colors.mantle },

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

function Dark.syntax(colors)
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
    ["@keyword.operator.c_sharp"] = { fg = colors.yellow },
    ["@keyword.coroutine.c_sharp"] = { fg = colors.yellow },

    -- dotnet lsp semantic tokens
    ["@lsp.type.keyword.cs"] = { link = "@lsp" }, -- disable "keyword" since everything is a "keyword" and uses only 1 color
    ["@lsp.type.class.cs"] = { fg = colors.trick },
    ["@lsp.type.struct.cs"] = { fg = colors.peach },
    ["@lsp.type.interface.cs"] = { fg = colors.green },
    ["@lsp.type.enum.cs"] = { fg = colors.flamingo },
    ["@lsp.type.namespace.cs"] = { fg = colors.peach, style = { "italic" } },

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
  local line = require("catppuccin.utils.lualine")("mocha")
  local colors = Dark.colors;

  line.normal = {
    a = { bg = colors.green, fg = colors.base, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.text, gui = "bold" },
    c = { bg = colors.dark, fg = colors.text },
    y = { fg = colors.teal }
  }

  line.insert = {
    a = { bg = colors.skyblue, fg = colors.mantle, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.skyblue },
  }

  line.terminal = {
    a = { bg = colors.pink, fg = colors.base, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.teal },
  }

  line.command = {
    a = { bg = colors.yellow, fg = colors.base, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.yellow },
  }

  line.visual = {
    a = { bg = colors.peach, fg = colors.base, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.peach },
  }

  line.replace = {
    a = { bg = colors.red, fg = colors.base, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.red },
  }

  line.inactive = {
    a = { bg = colors.dark, fg = colors.skyblue },
    b = { bg = colors.dark, fg = colors.surface1, gui = "bold" },
    c = { bg = colors.dark, fg = colors.overlay0 },
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
    rocks = {
      enabled = false,
    },
    defaults = {
      lazy = true, -- lazy load plugins by default
      version = false, -- always use the latest git commit
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "tutor",
          "tohtml",
          "tarPlugin",
          "zipPlugin",
          "netrwPlugin",
        }
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
      nvimtree = true,
      blink_cmp = true,
      which_key = true,
      lsp_trouble = true,
    },
    color_overrides = { mocha = Dark.colors },
    highlight_overrides = {
      mocha = function(colors)
        return vim.tbl_extend("error", Dark.editor(colors), Dark.syntax(colors))
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
-- Lazy.use { "mrcjkb/rustaceanvim", ft = "rust", version = "^4" }

-- stylus syntax
Lazy.use { "wavded/vim-stylus", ft = "stylus" }

-- razor syntax -> adamclerk/vim-razor
Lazy.use { "jlcrochet/vim-razor", ft = { "razor", "cshtml" } }

-- roslyn.nvim -> c-sharp dotnet lsp -> Microsoft.CodeAnalysis.LanguageServer
Lazy.use { "seblj/roslyn.nvim", ft = "cs", opts = { config = { filetypes = { "cs" } } } }

-- auto close/rename html tag
-- Lazy.use { "andrewradev/tagalong.vim", ft = { "html", "cshtml", "razor", "markdown" }, enabled = false }

-- auto close/rename html tag
Lazy.use { "windwp/nvim-ts-autotag", ft = { "html", "cshtml", "razor", "markdown" }, opts = { opts = { enable_close_on_slash = true } } }

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

    vim.api.nvim_del_autocmd(tws_autocmd_id)
    vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = trim })
    vim.api.nvim_create_user_command("TrimTralingWhiteSpace", trim, { desc = "Trim Trailing White Space" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lazy",
      callback = function(data)
        vim.b[data.buf].minitrailspace_disable = true
        vim.api.nvim_buf_call(data.buf, MiniTrailspace.unhighlight)
      end
    })
  end
}

-- visualize and work with indent scope animated
Lazy.use {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
  opts = {
    draw = {
      delay = 16,
      animation = function() return 0 end
    }
  }
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

-- delete buffers without losing window layout
Lazy.use {
  "echasnovski/mini.bufremove",
  cmd = { "Bdelete", "Bwipeout" },
  keys = {
    { "<leader>q", "<cmd>Bdelete<cr>", silent = true, desc = "Quit Buffer" },
    { "<leader>w", "<cmd>Bwipeout<cr>", silent = true, desc = "Wipeout Buffer" }
  },
  init = function()
    -- override native bd
    vim.cmd[[cabbrev bd Bdelete]]
    vim.cmd[[cabbrev bdelete Bdelete]]

    -- override native bw
    vim.cmd[[cabbrev bw Bwipeout]]
    vim.cmd[[cabbrev bwipeout Bwipeout]]
  end,
  config = function()
    vim.api.nvim_create_user_command("Bdelete", function(opts) require("mini.bufremove").delete(tonumber(opts.args) or 0, opts.bang) end, { bang = true, nargs = "?" })
    vim.api.nvim_create_user_command("Bwipeout", function(opts) require("mini.bufremove").wipeout(tonumber(opts.args) or 0, opts.bang) end, { bang = true, nargs = "?" })
  end
}

-- minimap - window with buffer text overview
Lazy.use {
  "echasnovski/mini.map",
  event = "VeryLazy",
  -- keys = {{ "<leader>M", function() require("mini.map").toggle() end, silent = true, desc = "MiniMapToggle" }},
  opts = { window = { width = 1, show_integration_count = false } },
  config = function(_, options)
    require("mini.map").setup(options)
    require("mini.map").open()
  end
}

-- show notifications
Lazy.use {
  "echasnovski/mini.notify",
  event = "VeryLazy",
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
    update_focused_file = { enable = true },
  },
  keys = {
    { [[<leader>\\]], "<cmd>NvimTreeToggle<cr>", silent = true, desc = "NvimTreeToggle" },
    { [[<leader>\r]], "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { [[<leader>\f]], "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { [[<leader>\F]], "<cmd>NvimTreeFindFile!<cr>", silent = true, desc = "NvimTreeFindFile!" },
  }
}

-- show marks in the sign column
Lazy.use {
  "chentoast/marks.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    refresh_interval = 5000,
    default_mappings = false,
  },
  config = function(_, options)
    local marks = require("marks")
    marks.setup(options)
    vim.keymap.set("n", "gmm", marks.next, { silent = true, desc = "Go to next mark" })
    vim.keymap.set("n", "gmp", marks.prev, { silent = true, desc = "Go to prev mark" })
    vim.keymap.set("n", "gmd", marks.delete_buf, { silent = true, desc = "Delete marks" })
    vim.keymap.set("n", "<leader>m", marks.toggle, { silent = true, desc = "Mark Toggle" })
  end
}

-- git status signs
Lazy.use {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    trouble = false,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "[g", function() gs.nav_hunk("prev") end, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "]g", function() gs.nav_hunk("next") end, { buffer = buffer, silent = true, desc = "Next Hunk" })
      vim.keymap.set("n", "gsp", function() gs.nav_hunk("prev") end, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "gsn", function() gs.nav_hunk("next") end, { buffer = buffer, silent = true, desc = "Next Hunk" })
      vim.keymap.set("n", "gsl", function() gs.nav_hunk("last") end, { buffer = buffer, silent = true, desc = "Last Hunk" })
      vim.keymap.set("n", "gsf", function() gs.nav_hunk("first") end, { buffer = buffer, silent = true, desc = "First Hunk" })
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
Lazy.use {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 512,
  dependencies = {
    { "tiagovla/scope.nvim" }, -- scope buffers to tabs
    { "yavorski/lualine-lsp-progress.nvim" }, -- display lsp progress
    { "yavorski/lualine-lsp-client-name.nvim" }, -- display lsp client name
    { "yavorski/lualine-macro-recording.nvim" }, -- display macro recording
  },
  opts = function()
    local catppuccin = Dark.lualine()

    return {
      options = {
        theme = catppuccin,
        globalstatus = true,
        icons_enabled = true,
        section_separators = "", -- disable separators
        component_separators = "", -- disable separators
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename", "filesize", "lsp_progress", "macro_recording", "%S" },
        lualine_x = { "selectioncount", "searchcount", "lsp_client_name", "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
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
          filetype_names = {
            fzf = "FZF",
            lazy = "Lazy",
            NvimTree = "NvimTree",
            checkhealth = "CheckHealth",
            TelescopePrompt = "Telescope",
          },
        }},
        lualine_z = { "tabs" }
      },
      extensions = { "nvim-tree" }
    }
  end,
  config = function(_, options)
    require("scope").setup()
    require("lualine").setup(options)
  end
}

-- fzf
local vertical = {
  preview = {
    layout = "vertical",
    vertical = "down:75%",
    border = "border-top",
  }
}

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
      jump_to_single_result = true,
      file_ignore_patterns = { "package%-lock%.json" }
    },
    fzf_colors = true,
    fzf_opts = {
      ["--cycle"] = "",
      ["--scrollbar"] = "█",
      ["--preview-window"] = "bottom:75%,border-top", -- ["--preview-window"] = "right:50%,border-left",
      ["--color"] = string.format("preview-bg:%s,preview-scrollbar:%s", Dark.colors.mantle, Dark.colors.peach), -- FzfLuaBorder border is applied to native fzf window...
    },
    winopts = {
      row = 0.45,
      col = 0.495,
      width = 0.80,
      height = 0.87,
      border = "thicc",
      backdrop = 100,
      preview = {
        default = "builtin",
        border = "border",
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
      winopts = vertical,
      code_actions = { winopts = vertical },
    },
    grep = { winopts = vertical },
    git = { status = { winopts = vertical } },
    files = { fd_opts = nil, find_opts = nil },
    diagnostics = { winopts = vertical, multiline = false },
    -- manpages = { cmd = "man -s 1 -k ." },
    helptags = {
      fzf_opts = {
        ["--tac"] = "",
        ["--tiebreak"] = "begin,length,index",
      }
    },
  },
  keys = {
    { "<leader>tt", "<cmd>FzfLua<cr>", silent = true, desc = "FZF Lua" },
    { "<leader>b", "<cmd>FzfLua buffers<cr>", silent = true, desc = "FZF Buffers" },
    { "<leader>/", "<cmd>FzfLua live_grep_native<cr>", silent = true, desc = "FZF Search" },
    { "<leader>f", "<cmd>FzfLua files header=false<cr>", silent = true, desc = "FZF Files" },
    { "<leader>j", "<cmd>FzfLua jumps<cr>", silent = true, desc = "FZF Jumps List" },
    { "<leader>h", "<cmd>FzfLua helptags<cr>", silent = true, desc = "FZF Help Tags" },
    { "<leader>M", "<cmd>FzfLua manpages<cr>", silent = true, desc = "FZF Man Pages" },
    { "<leader>g", "<cmd>FzfLua git_status<cr>", silent = true, desc = "FZF Git Status" },
    { "<leader>'", "<cmd>FzfLua resume<cr>", silent = true, desc = "FZF Resume" },
  },
  config = function(_, options)
    local A = require("fzf-lua.actions")

    --- @diagnostic disable-next-line
    A.file_tabedit = function(selected, opts)
      local vimcmd = "tabnew | <auto>"
      A.vimcmd_entry(vimcmd, selected, opts)
    end

    require("fzf-lua").setup(options)

    require("fzf-lua").register_ui_select(function(opts)
      local ui_select = { row = 0.25, width = 0.7, height = 0.42 }
      return { winopts = opts.kind == "codeaction" and vertical or ui_select }
    end)
  end
}

-- diagnostics, references, fzf-lua/telescope results, quickfix and location list
Lazy.use {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  keys = {{ "<A-t>", "<cmd>Trouble<cr>", silent = true, desc = "Trouble" }},
  opts = {
    auto_close = true, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = true, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = true, -- auto jump to the item when there's only one
    focus = true, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = true, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
  },
  config = function(_, options)
    require("trouble").setup(options)
    require("fzf-lua.config").defaults.actions.files["alt-t"] = require("trouble.sources.fzf").actions.open
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
    ignore_install = { "hoon" },
    indent = { enable = true }, -- indentation for = operator
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
        scope_incremental = false,
        node_decremental = "<bs>"
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
        }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
        d = { "%f[%d]%d+" }, -- digits
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
-- LSP - setup
-- neovim/nvim-lspconfig
------------------------------------------------------------
local LSP = {
  opts = {
    border = "single",

    diagnostics = {
      signs = true,
      underline = false,
      virtual_text = true,
      severity_sort = true,
      update_in_insert = false,
      float = { border = "single" },
      icons = { Info = "▪", Hint = "★", Warn = "◮", Error = "✖" }
    },

    servers = {
      "html",
      "cssls",
      "taplo",
      "bashls",
      "jsonls",
      "yamlls",
      "nushell",
      "dockerls",
      "rust_analyzer",
      -- "tsserver",
      -- "angularls",
      -- "powershell",
      -- "roslyn/dotnet"
      -- "azure_pipelines_ls",
      -- "lua-language-server",
      -- "emmet_language_server",
    }
  }
}

------------------------------------------------------------
-- LSP init settings and servers
------------------------------------------------------------
LSP.init = function()
  LSP.UI()
  LSP.keymaps()
  LSP.overloads()
  LSP.setup_lua()
  LSP.setup_emmet()
  LSP.setup_angular()
  LSP.setup_powershell()
  LSP.setup_listed_servers()
  LSP.setup_azure_pipelines()
end

------------------------------------------------------------
-- LSP user interface settings
------------------------------------------------------------
LSP.UI = function()
  vim.diagnostic.config(LSP.opts.diagnostics)

  for type, icon in pairs(LSP.opts.diagnostics.icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  require("lspconfig.ui.windows").default_options.border = LSP.opts.border

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = LSP.opts.border })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = LSP.opts.border })
end

------------------------------------------------------------
-- LSP buffer keymaps
------------------------------------------------------------
LSP.buffer_keymaps = function(buffer)
  -- enable completion triggered by <c-x><c-o>
  vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- key map fn
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = buffer, desc = desc })
  end

  -- keymap("n", "gr", vim.lsp.buf.references, "LSP References")
  keymap("n", "gr", "<cmd>FzfLua lsp_references<cr>", "LSP References")

  -- keymap("n", "gd", vim.lsp.buf.definition, "LSP Definition")
  keymap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "LSP Definition")

  -- keymap("n", "gD", vim.lsp.buf.declaration, "LSP Declaration")
  keymap("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "LSP Declaration")

  -- keymap("n", "gi", vim.lsp.buf.implementation, "LSP Implementation")
  keymap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "LSP Implementation")

  -- keymap("n", "g<space>", vim.lsp.buf.type_definition, "LSP Type Definition")
  keymap("n", "g<space>", "<cmd>FzfLua lsp_typedefs<cr>", "LSP Type Definition")

  -- default is K
  keymap({ "n", "v" }, "<leader>k", vim.lsp.buf.hover, "LSP Hover")
  keymap({ "n", "v" }, "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")

  keymap({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, "LSP Rename")
  keymap({ "n", "v" }, "<leader>R", vim.lsp.buf.rename, "LSP Rename")

  keymap({ "n", "v" }, "<leader>A", vim.lsp.buf.code_action, "LSP Code Action") -- with preview
  keymap({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions previewer=false winopts.row=0.25 winopts.width=0.7 winopts.height=0.42<cr>", "LSP Code Action") -- no preview

  -- <CTRL-W-d> is default
  keymap("n", "<leader>er", vim.diagnostic.open_float, "LSP Diagnostic Open Float")

  keymap("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format")
  keymap("v", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format Visual")

  keymap("n", "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", "LSP Document Diagnostics")
  keymap("n", "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", "LSP Workspace Diagnostics")

  keymap("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, "LSP Add Workspace Folder")
  keymap("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, "LSP Remove Workspace Folder")
  keymap("n", "<leader>Wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP Workspace List Folders")
end

------------------------------------------------------------
-- LSP - attach keymaps on LspAttach event
------------------------------------------------------------
LSP.keymaps = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      LSP.buffer_keymaps(event.buf)
    end
  })
end

------------------------------------------------------------
-- LSP - client capabilities
------------------------------------------------------------
LSP.capabilities = function()
  -- client capabilities
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()

  -- additional capabilities
  local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

  -- @perf: didChangeWatchedFiles is too slow
  -- @todo: Remove this when https://www.github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed
  local workarround_perf_fix = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    }
  }

  local capabilities = vim.tbl_deep_extend("force", {}, client_capabilities, lsp_capabilities, workarround_perf_fix)

  return capabilities
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
          ui = {
            silent = true,
            border = "single"
          },
          keymaps = {
            next_signature = "<A-n>",
            previous_signature = "<A-p>",
            close_signature = "<esc>"
          }
        })

        vim.keymap.set({ "n", "i" }, "<A-o>", show_lsp_signature_overloads, { silent = false });
        -- vim.keymap.set({ "n", "i" }, "<C-S-Space>", show_lsp_signature_overloads, { silent = false });
      end
    end
  })
end

------------------------------------------------------------
-- LSP - setup listed servers from options
------------------------------------------------------------
LSP.setup_listed_servers = function()
  local lsp = require("lspconfig")
  local servers = LSP.opts.servers

  for _, server in ipairs(servers) do
    lsp[server].setup({
      capabilities = LSP.capabilities()
    })
  end
end

------------------------------------------------------------
-- LSP Angular
------------------------------------------------------------
LSP.setup_angular = function()
  local npm = is_windows and "$APPDATA/npm" or "$HOME/.npm/lib"
  local ts_path = vim.fn.expand(npm .. "/node_modules/typescript/lib")
  local als_path = vim.fn.expand(npm .. "/node_modules/@angular/language-server/bin")
  local server_cmd = { "ngserver", "--stdio", "--tsProbeLocations", ts_path, "--ngProbeLocations", als_path }

  require("lspconfig").angularls.setup({
    cmd = server_cmd,
    filetypes = { "html" },
    capabilities = LSP.capabilities(),
    on_new_config = function(new_config)
      new_config.cmd = server_cmd
    end
  })
end

------------------------------------------------------------
-- LSP Lua lus_ls -- sumneko/lua-language-server
------------------------------------------------------------
LSP.setup_lua = function()
  require("lspconfig").lua_ls.setup({
    capabilities = LSP.capabilities(),
    settings = {
      Lua = {
        format = { enable = true },
        runtime = { version = "LuaJIT" },
        completion = { callSnippet = "Replace" },
        workspace = { checkThirdParty = "Disable" },
        diagnostics = {
          globals = { "vim" },
          -- disable = { "missing-fields" },
        }
      }
    }
  })
end

------------------------------------------------------------
-- LSP Emmet
------------------------------------------------------------
LSP.setup_emmet = function()
  require("lspconfig").emmet_language_server.setup({
    filetypes = {
      "html", "pug", "eruby", "cshtml", "razor",
      -- "css", "less", "sass", "scss", "stylus",
      -- "javascript", "javascriptreact", "typescriptreact",
    }
  })
end

------------------------------------------------------------
-- LSP powershell
-- https://github.com/powershell/powershelleditorservices
-- pacman -S [AUR] powershell-bin powershell-editor-services
------------------------------------------------------------
LSP.setup_powershell = function()
  local win_path = "C:/dev/ps-es-lsp"
  local linux_path = "/opt/powershell-editor-services"

  require("lspconfig").powershell_es.setup({
    capabilities = LSP.capabilities(),
    bundle_path = is_windows and win_path or linux_path
  })
end

------------------------------------------------------------
-- LSP azure pipelines
------------------------------------------------------------
LSP.setup_azure_pipelines = function()
  local lsp = require("lspconfig")
  local patterns = { "azure*.yml", ".azure/*.yml", "pipelines/*.yml", "azure-pipelines/*.yml" }
  local service_schema = "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"

  lsp.azure_pipelines_ls.setup({
    capabilities = LSP.capabilities(),
    root_dir = lsp.util.root_pattern(patterns),
    single_file_support = true,
    settings = {
      yaml = {
        schemas = {
          [service_schema] = patterns
        }
      }
    }
  })
end

------------------------------------------------------------
-- Lazy LSP setup
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
    appearance = {
      nerd_font_variant = "mono",
      use_nvim_cmp_as_default = false
    },

    signature = {
      enabled = true,
      window = { border = "single" }
    },

    term = { enabled = false },

    sources = {
      default = { "lsp", "path", "buffer" },
      per_filetype = { sql = { "dadbod", "buffer" } },
      providers = {
        lsp = {
          name = "LSP",
          fallbacks = {},
          score_offset = 1024,
          should_show_items = function(_, items)
            -- remove always suggested closing tag by html server
            return not (#items == 1 and vim.tbl_contains({ "html", "razor", "cshtml" }, vim.bo.filetype) and vim.startswith(items[1].label, "</"))
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
        return vim.tbl_contains({ "html", "razor", "cshtml", "markdown" }, vim.bo.filetype) and 1 or 0
      end
    },

    completion = {
      menu = {
        auto_show = true,
        max_height = 18,
        border = "single",
        draw = { align_to = "none" }
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
          border = "single"
        }
      },
      keyword = { range = "prefix" },
      ghost_text = { enabled = true },
    },

    keymap = {
      preset = "none",
      ["<C-a>"] = { "hide" },
      ["<C-c>"] = { "cancel" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "select_and_accept", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
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
        menu = {
          auto_show = false
        }
      },
      keymap = {
        preset = "none",
        ["<C-a>"] = { "hide" },
        ["<C-c>"] = { "cancel" },
        ["<C-w>"] = { "hide", "cancel", "fallback" },
        ["<C-e>"] = { "select_and_accept", "fallback" },
        ["<C-n>"] = { "show", "select_next", "fallback" },
        ["<C-p>"] = { "show", "select_prev", "fallback" },
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

-- close trouble
local function close_trouble()
  local is_trouble_loaded, trouble = pcall(require, "trouble")
  if is_trouble_loaded then
    if trouble.is_open() then
      trouble.close()
    end
  end
end

-- reopen mini map
local function reopen_minimap()
  local is_minimap_loaded, minimap = pcall(require, "mini.map")
  if is_minimap_loaded then
    minimap.open()
  end
end

-- clear mini jump
local function stop_jumping()
  local is_minijump_loaded, minijump = pcall(require, "mini.jump")
  if is_minijump_loaded then
    if minijump.state.jumping then
      minijump.stop_jumping()
    end
  end
end

-- escape fn
local function escape()
  close_trouble()
  close_qf_loc_list()
  vim.cmd("silent! fclose!")
  stop_jumping()
  reopen_minimap()
end

-- map <esc> key
vim.keymap.set("n", "<esc>", escape, { silent = true, noremap = true, desc = "Escape" })

------------------------------------------------------------
-- NeoVide
------------------------------------------------------------

if vim.g.neovide then
  vim.opt.linespace = is_linux and 0 or 2
  vim.g.neovide_remember_window_size = true
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

--------------------------------------------------------------------------------
-- Required in path
--------------------------------------------------------------------------------
-- npm i -g @angular/language-server
-- npm i -g emmet-ls [ issues/outdated ]
-- npm i -g @olrtg/emmet-language-server
-- npm i -g azure-pipelines-language-server
-- npm i -g dockerfile-language-server-nodejs
-- npm i -g bash-language-server
-- pacman -S bash-language-server

-- npm i -g typescript typescript-language-server
-- pacman -S typescript typescript-language-server

-- [ html, css, json, eslint, markdown ]
-- npm i -g vscode-langservers-extracted
-- pacman -S eslint-language-server
-- pacman -S vscode-css-languageserver
-- pacman -S vscode-html-languageserver
-- pacman -S vscode-json-languageserver
-- pacman -S vscode-markdown-languageserver

-- pacman -S zig zls
-- pacman -S gcc clang
-- pacman -S taplo taplo-cli
-- pacman -S rust rust-analyzer
-- pacman -S lua-language-server
-- pacman -S yaml-language-server
-- pacman -S shellcheck
-- pacman -S [AUR] shellcheck-bin
-- pacman -S gopls
-- pacman -S pyright python-lsp-server
-- pacman -S tree-sitter tree-sitter-cli
-- pacman -S fd ripgrep curl nodejs tree-sitter ttf-nerd-fonts-symbols-mono
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Roslyn
--------------------------------------------------------------------------------

-- Download `Microsoft.CodeAnalysis.LanguageServer.linux-x64` pkg from https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl
-- extract and move the contents of <zip-root>/content/LanguageServer/<yourArch> inside:
-- Linux: ~/.local/share/nvim/roslyn
-- Windows: %LOCALAPPDATA%\nvim-data\roslyn
-- Verify by running `dotnet Microsoft.CodeAnalysis.LanguageServer.dll --version` in `roslyn` directory

--------------------------------------------------------------------------------
-- LSP server configurations
--------------------------------------------------------------------------------
-- https://github.com/neovim/nvim-lspconfig
--------------------------------------------------------------------------------
