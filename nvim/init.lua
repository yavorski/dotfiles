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
vim.opt.clipboard = "unnamedplus"

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
vim.g.rust_recommended_style = 0

-- enable tabs for the following filetypes
vim.cmd[[autocmd FileType ps1 setlocal noexpandtab]]
vim.cmd[[autocmd FileType make setlocal noexpandtab]]
vim.cmd[[autocmd FileType rust setlocal noexpandtab]]

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
-- Buffer navigation
------------------------------------------------------------

-- standard prev/next
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "gbp", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "gbn", "<cmd>bnext<cr>", { silent = true })

-- require nvim-lualine/lualine.nvim plugin
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
    rosewater = "#f5e0dc", -- -- "#f5e0dc" -- -- Winbar
    flamingo  = "#f2cdcd", -- -- "#f2cdcd" -- -- Target word
    pink      = "#ff1493", -- -- "#f5c2e7" -- -- [!] Just pink
    mauve     = "#c678dd", -- -- "#cba6f7" -- -- [!] Tag
    red       = "#e95678", -- -- "#f38ba8" -- -- [!] Error
    maroon    = "#d16d9e", -- -- "#eba0ac" -- -- [!] Lighter red
    peach     = "#f5a97f", -- -- "#fab387" -- -- [!] Number
    yellow    = "#faf76e", -- -- "#f9e2af" -- -- [!] Warning
    green     = "#4bf99e", -- -- "#a6e3a1" -- -- [!] Diff add
    teal      = "#94e2d5", -- -- "#94e2d5" -- -- Hint
    sky       = "#89dceb", -- -- "#89dceb" -- -- Operator
    sapphire  = "#36d0e0", -- -- "#74c7ec" -- -- Constructor
    blue      = "#4ba6f9", -- -- "#89b4fa" -- -- [!] Diff changed
    lavender  = "#89b4fa", -- -- "#b4befe" -- -- [!] CursorLine Nr
    text      = "#cdd6f4", -- -- "#cdd6f4" -- -- Default fg
    subtext1  = "#bac2de", -- -- "#bac2de" -- -- Indicator
    subtext0  = "#a6adc8", -- -- "#a6adc8" -- -- Float title
    overlay2  = "#9399b2", -- -- "#9399b2" -- -- Popup fg
    overlay1  = "#7f849c", -- -- "#7f849c" -- -- Conceal color
    overlay0  = "#6c7086", -- -- "#6c7086" -- -- Fold color
    surface2  = "#585b70", -- -- "#585b70" -- -- Default comment
    surface1  = "#45475a", -- -- "#45475a" -- -- Darker comment
    surface0  = "#313244", -- -- "#313244" -- -- Darkest comment
    base      = "#1e1e2e", -- -- "#1e1e2e" -- -- Default bg
    mantle    = "#181825", -- -- "#181825" -- -- Darker bg
    crust     = "#11111b", -- -- "#11111b" -- -- Darkest bg
    trick     = "#1abc9c", -- -- "#1abc9c" -- -- [*] Trick
    stealth   = "#14ff80", -- -- "#14ff80" -- -- [*] Type
    skyblue   = "#54b9f7", -- -- "#41b2f7" -- -- [*] Sky blue
    mantlex   = "#161622", -- -- "#14141f" -- -- [*] Darker bg
    dark      = "#13131d", -- -- "#151521" -- -- [*] Darker bg
  }
}

function Dark.editor(colors)
  local mocha = require("catppuccin.palettes.mocha")
  return {
    -- nvim
    LineNr = { bg = colors.mantle },
    VertSplit = { fg = colors.crust, bg = colors.crust },

    FoldColumn = { bg = colors.mantle },
    SignColumn = { bg = colors.mantle },
    SignColumnSB = { bg = colors.mantle },

    MsgArea = { bg = colors.dark },
    FloatBorder = { fg = colors.blue, bg = colors.mantle },

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

    -- nvim marks
    MarkSignHL = { bg = colors.mantle },
    MarkSignNumHL = { bg = colors.mantle },

    -- nvim tree
    NvimTreeRootFolder = { fg = colors.peach },
    NvimTreeWinSeparator = { fg = colors.crust, bg = colors.crust },
    NvimTreeFolderName = { fg = colors.skyblue },
    NvimTreeFolderIcon = { fg = colors.skyblue },

    -- nvim gitsigns
    GitSignsAdd = { fg = colors.green, bg = colors.mantle },
    GitSignsChange = { fg = colors.yellow, bg = colors.mantle },
    GitSignsDelete = { fg = colors.red, bg = colors.mantle },

    -- nvim telescope
    TelescopeSelection = { bg = colors.surface0 },
    TelescopeSelectionCaret = { fg = colors.flamingo },
    TelescopePromptCounter = { fg = colors.flamingo },
    TelescopePromptPrefix = { bg = colors.surface0 },
    TelescopePromptNormal = { bg = colors.surface0 },
    TelescopeResultsNormal = { bg = colors.mantlex },
    TelescopePreviewNormal = { bg = colors.crust },
    TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
    TelescopeResultsBorder = { bg = colors.mantlex, fg = colors.mantlex },
    TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
    TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
    TelescopeResultsTitle = { fg = colors.mantlex, bg = colors.mantlex },
    TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
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
    a = { bg = colors.green, fg = colors.base, gui = "bold" },
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
    flavour = "mocha",
    background = {
      dark = "mocha",
      light = "mocha"
    },
    term_colors = true,
    transparent_background = false,
    integrations = { which_key = true },
    color_overrides = { mocha = Dark.colors },
    highlight_overrides = {
      mocha = function(colors)
        return vim.tbl_extend("error", Dark.editor(colors), Dark.syntax(colors))
      end
    },
  },
  config = function(plugin, opts)
    require("catppuccin").setup(opts)
    vim.cmd[[ colorscheme catppuccin ]]
  end
}

-- utility lib
Lazy.use { "nvim-lua/plenary.nvim" }

-- nvim dev icons
Lazy.use { "nvim-tree/nvim-web-devicons" }

-- rust.vim
Lazy.use { "rust-lang/rust.vim", ft = "rust" }
-- Lazy.use { "mrcjkb/rustaceanvim", ft = "rust", version = "^4" }

-- stylus syntax
Lazy.use { "wavded/vim-stylus", ft = "stylus" }

-- razor syntax -> adamclerk/vim-razor
Lazy.use { "jlcrochet/vim-razor", ft = { "razor", "cshtml" } }

-- emmet html/css/js/lorem - [i] <c-m> <c-y>,
Lazy.use { "mattn/emmet-vim", ft = { "html", "cshtml", "razor", "markdown" } }

-- auto close/rename html tag
-- Lazy.use { "andrewradev/tagalong.vim", ft = { "html", "cshtml", "razor", "markdown" }, enabled = false }

-- auto close/rename html tag
Lazy.use { "windwp/nvim-ts-autotag", ft = { "html", "cshtml", "razor", "markdown" }, opts = { opts = { enable_close_on_slash = true } } }

-- shows key bindings in popup
Lazy.use { "folke/which-key.nvim", event = "VeryLazy", config = true }

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

-- show notifications - same issue like noice while search
-- Lazy.use { "echasnovski/mini.notify", event = "VeryLazy", config = true }

-- misc fns - put, put_text, setup_auto_root, setup_restore_cursor, zoom
Lazy.use { "echasnovski/mini.misc", event = "VeryLazy", config = true, priority = 1 }

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

-- split/join code blocks, fn args, arrays, tables - [n,v] <sj>
Lazy.use {
  "echasnovski/mini.splitjoin",
  event = "VeryLazy",
  config = function()
    local splitjoin = require("mini.splitjoin")
    local pad_brackets = splitjoin.gen_hook.pad_brackets()
    local del_separator = splitjoin.gen_hook.del_trailing_separator()

    splitjoin.setup({
      mappings = { toggle = "sj" },
      join = {
        hooks_post = {
          pad_brackets,
          del_separator
        }
      }
    })

    require("which-key").register({ sj = "Toggle Split Join" })
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
    vim.api.nvim_create_user_command("Bdelete", function(opts) require("mini.bufremove").delete(0, opts.bang) end, { bang = true })
    vim.api.nvim_create_user_command("Bwipeout", function(opts) require("mini.bufremove").wipeout(0, opts.bang) end, { bang = true })
  end
}

-- minimap - window with buffer text overview
Lazy.use {
  "echasnovski/mini.map",
  event = "VeryLazy",
  keys = {{ "<leader>M", function() require("mini.map").toggle() end, silent = true, desc = "MiniMapToggle" }},
  opts = { window = { width = 1, show_integration_count = false } },
  config = function(plugin, options)
    require("mini.map").setup(options)
    require("mini.map").open()
  end
}

-- file explorer sidebar
Lazy.use {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "NvimTreeToggle",
  opts = {
    git = { timeout = 2048 },
    update_focused_file = { enable = true },
  },
  keys = {
    { "<leader>kb", "<cmd>NvimTreeToggle<cr>", silent = true, desc = "NvimTreeToggle" },
    { "<leader>kr", "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { "<leader>kf", "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { "<leader>ko", "<cmd>NvimTreeFindFile!<cr>", silent = true, desc = "NvimTreeFindFile!" },
    { "<leader>K", function() require("nvim-tree.api").tree.toggle({ focus = false }) end, silent = true, desc = "NvimTreeToggle" }
  }
}

-- show marks in the sign column
Lazy.use {
  "chentoast/marks.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    refresh_interval = 420,
    default_mappings = false,
    mappings = {
      set = "m", -- "mx" set "x" mark
      delete = "dm", -- "dmx" del "x" mark
      set_next = "mn", -- set next lower case letter
      delete_line = "dm-", -- delete marks on curent line
      delete_buf = "dm<space>", -- delete marks in current buffer
      prev = "mM", -- go to prev mark
      next = "mm", -- go to next mark
    }
  }
}

-- git status signs
Lazy.use {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    trouble = false,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "[h", function() gs.nav_hunk("prev") end, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "]h", function() gs.nav_hunk("next") end, { buffer = buffer, silent = true, desc = "Next Hunk" })
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
  },
  init = function()
    require("which-key").register({ gs = "Git Signs" })
  end
}

-- statusline
Lazy.use {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 512,
  dependencies = {
    { "tiagovla/scope.nvim" }, -- scope buffers to tabs
    { "nvim-tree/nvim-web-devicons" }, -- use nvim dev icons
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
  config = function(plugin, options)
    require("scope").setup()
    require("lualine").setup(options)
  end
}

-- fzf
Lazy.use {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    winopts = {
      preview = {
        default = "bat",
        tags = { previewer = "bat" },
        btags = { previewer = "bat" },
      }
    },
    keymap = {
      builtin = {
        ["<C-u>"] = "preview-page-up",
        ["<C-d>"] = "preview-page-down"
      },
      fzf = {
        ["ctrl-b"] = "half-page-up",
        ["ctrl-f"] = "half-page-down",
        ["shift-up"] = "preview-page-up",
        ["shift-down"]  = "preview-page-down"
      }
    },
    git = {
      status = { winopts = { preview = { layout = "vertical", vertical = "down:75%" } } },
      commits = { winopts = { preview = { layout = "vertical", vertical = "down:75%" } } },
      bcommits = { winopts = { preview = { layout = "vertical", vertical = "down:75%" } } }
    },
    lsp = {
      winopts = {
        preview = { layout = "vertical", vertical = "down:70%" }
      },
      code_actions = {
        previewer = "codeaction_native",
        preview_pager = [[ delta --hunk-header-style="omit" --file-style="omit" --width=$FZF_PREVIEW_COLUMNS ]],
        winopts = { preview = { scrollbar = false, layout = "vertical", vertical = "down:75%" } }
      },
    },
    diagnostics = {
      winopts = { preview = { layout = "vertical", vertical = "down:70%" } }
    }
  },
  config = function(plugin, opts)
    require("fzf-lua").setup(opts)
    -- require("fzf-lua").register_ui_select()
  end
}

-- Telescope - find, filter, preview, pick
-- local fzf_windows_native = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
Lazy.use {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  event = is_windows and "VeryLazy" or nil,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "echasnovski/mini.fuzzy", enabled = is_windows },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", config = function() require("telescope").load_extension("fzf") end, enabled = is_linux }
  },
  opts = {
    defaults = {
      sorting_strategy = "ascending",
      file_ignore_patterns = { "^.git/", "^.git\\", "node_modules", "wwwroot/lib", "bin", "obj", "debug" },
      vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "--trim" },
      layout_config = {
        vertical = { preview_height = 0.55 },
        horizontal = { preview_width = 0.50 },
      },
    },
    pickers = {
      find_files = {
        hidden = true
      },
      lsp_references = {
        trim_text = false,
        include_declaration = true,
        include_current_line = true,
        initial_mode = "normal",
        mappings = {
          n = {
            ["<C-n>"] = "move_selection_next",
            ["<C-p>"] = "move_selection_previous"
          }
        }
      }
    }
  },
  keys = {
    { "<leader>T", "<cmd>Telescope<cr>", silent = true, desc = "Telescope" },
    { "<leader>tt", "<cmd>Telescope<cr>", silent = true, desc = "Telescope" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", silent = true, desc = "Telescope Buffers" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", silent = true, desc = "Telescope Search" },
    { "<leader>f", "<cmd>Telescope find_files<cr>", silent = true, desc = "Telescope Files" },
    { "<leader>tc", "<cmd>Telescope commands<cr>", silent = true, desc = "Telescope Commands" },
    { "<leader>tj", "<cmd>Telescope jumplist<cr>", silent = true, desc = "Telescope Jump List" },
    { "<leader>tm", "<cmd>Telescope man_pages<cr>", silent = true, desc = "Telescope Man Pages" },
    { "<leader>th", "<cmd>Telescope help_tags<cr>", silent = true, desc = "Telescope Help Tags" },
    { "<leader>tg", "<cmd>Telescope git_status<cr>", silent = true, desc = "Telescope Git Status" },
  },
  config = function(plugin, options)
    if is_windows then
      local fuzzy = require("mini.fuzzy")
      options.defaults.generic_sorter = fuzzy.get_telescope_sorter
    end
    require("telescope").setup(options)
  end,
  init = function()
    require("which-key").register({ ["<leader>t"] = "Telescope" })
  end
}

-- select ui - lsp code actions
Lazy.use {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = { enabled = false },
    select = {
      enabled = true,
      trim_prompt = false,
      backend = { "builtin", "fzf_lua" },
      builtin = {
        border = "solid",
        min_width = { 80, 0.2 },
        min_height = { 4, 0.1 },
        win_options = { winhighlight = "FloatTitle:FloatBorder" }
      }
    }
  }
}

-- NOTE TODO telescope integration
-- diagnostics, references, telescope results, quickfix and location list
Lazy.use {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleQuickFixList" },
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
  config = function(plugin, options)
    require("trouble").setup(options)
    vim.api.nvim_create_user_command("TroubleFocus", require("trouble").focus, { });
    vim.api.nvim_create_user_command("TroubleClose", require("trouble").close, { });
    vim.api.nvim_create_user_command("TroubleQuickFixList", "Trouble quickfix", { });
  end
}

-- NOTE enable when these are resolved
-- ui for messages, cmdline, search and popupmenu
-- https://www.github.com/neovim/neovim/pull/27950
-- https://www.github.com/folke/noice.nvim/issues/679
Lazy.use {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = false,
  dependencies = {{ "muniftanjim/nui.nvim" }},
  opts = {
    notify = { view = "mini" },
    messages = { enabled = true },
    popupmenu = { kind_icons = false },
    cmdline_output = { enabled = true },
    presets = {
      command_palette = true,
      long_message_to_split = true,
      cmdline_output_to_split = false,
    },
    cmdline = {
      view = "cmdline_popup",
      format = {
        lua = { icon = "" },
        help = { icon = "" },
        filter = { icon = "$" },
        cmdline = { icon = "" },
        search_up = { icon = "🔍⇡" },
        search_down = { icon = "🔍⇣" }
      }
    },
    lsp = {
      hover = { enabled = false },
      message = { enabled = true },
      progress = { enabled = true },
      signature = { enabled = false },
      documentation = { enabled = false }
    },
    commands = {
      history = { view = "popup" }
    },
    routes = {
      { view = "notify", filter = { event = "msg_showmode" } },
      { view = "split", filter = { event = "msg_show", min_height = 10 } },
    },
    format = {
      level = { icons = { error = "✖ ", warn = "◀ ", info = "▣ " } }
    },
    views = {
      notify = { merge = true, replace = true },
      messages = { view = "popup", enter = true },
      confirm = {
        border = { style = "none", padding = { 1, 2 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      },
      popup = {
        border = { style = "none", padding = { 1, 2 } }
      },
      popupmenu = {
        size = { max_height = 32 },
        border = { style = "single", padding = { 0, 1 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } },
      },
      cmdline_popup = {
        align = "center",
        position = { row = 8, col = "50%" },
        size = { width = 80, height = "auto" },
        border = { style = "none", padding = { 1, 2 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      },
      cmdline_popupmenu = {
        position = { row = 12, col = "50%" },
        size = { width = 80, height = "auto" },
        border = { style = "none", padding = { 1, 2 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      },
      mini = {
        timeout = 2800,
        focusable = false,
        border = { style = "none", padding = { 1, 2 } },
        position = { row = 3, col = "98%" },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      }
    }
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
    indent = { enable = true }, -- indentation for = operator
    playground = { enable = false }, -- Inspect/TSHighlightCapturesUnderCursor
    highlight = {
      enable = true, -- false will disable the extension
      disable = function(lang, buf)
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
  config = function(plugin, options)
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
  config = function(plugin, options)
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
    border = "solid",

    diagnostics = {
      signs = true,
      underline = false,
      virtual_text = true,
      severity_sort = true,
      update_in_insert = false,
      float = { border = "solid" },
      icons = { Info = "▪", Hint = "★", Warn = "◮", Error = "✖" }
    },

    servers = {
      "html",
      "cssls",
      "taplo",
      "bashls",
      "jsonls",
      "yamlls",
      "dockerls",
      "rust_analyzer",
      "emmet_language_server",
      -- "emmet_ls",
      -- "tsserver",
      -- "angularls",
      -- "csharp_ls",
      -- "omnisharp",
      -- "powershell",
      -- "omnisharp-roslyn",
      -- "azure_pipelines_ls",
      -- "lua-language-server",
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
  LSP.setup_dotnet()
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

  keymap("n", "gr", vim.lsp.buf.references, "LSP References")
  keymap("n", "<leader>gr", "<cmd>Trouble lsp_references toggle<cr>", "LSP References")

  keymap("n", "gd", vim.lsp.buf.definition, "LSP Definition")
  keymap("n", "<leader>gd", "<cmd>Trouble lsp_definitions toggle<cr>", "LSP Definition")

  keymap("n", "gD", vim.lsp.buf.declaration, "LSP Declaration")
  keymap("n", "<leader>gD", "<cmd>Trouble lsp_declarations toggle<cr>", "LSP Declaration")

  keymap("n", "gi", vim.lsp.buf.implementation, "LSP Implementation")
  keymap("n", "<leader>gi", "<cmd>Trouble lsp_implementations toggle<cr>", "LSP Implementation")

  keymap("n", "g<space>", vim.lsp.buf.type_definition, "LSP Type Definition")
  keymap("n", "<leader>g<space>", "<cmd>Trouble lsp_type_definitions toggle<cr>", "LSP Type Definition")

  -- keymap("n", "K", vim.lsp.buf.hover, "LSP Hover")
  keymap("n", "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")

  keymap("n", "<leader>r", vim.lsp.buf.rename, "LSP Rename")
  keymap("n", "<leader>R", vim.lsp.buf.rename, "LSP Rename")

  keymap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
  keymap("v", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")

  -- <CTRL-W-d> is default
  keymap("n", "<leader>er", vim.diagnostic.open_float, "LSP Diagnostic Open Float")

  keymap("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format")
  keymap("v", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format Visual")

  keymap("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", "LSP Workspace Diagnostics")
  keymap("n", "<leader>D", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "LSP Document Diagnostics")

  keymap("n", "<leader>tq", "<cmd>Telescope diagnostics layout_strategy=vertical<cr>", "Telescope LSP Diagnostics")
  keymap("n", "<leader>tr", "<cmd>Telescope lsp_references layout_strategy=vertical<cr>", "Telescope LSP References")
  keymap("n", "<leader>td", "<cmd>Telescope lsp_definitions layout_strategy=vertical<cr>", "Telescope LSP Definitions")
  keymap("n", "<leader>ti", "<cmd>Telescope lsp_implementations layout_strategy=vertical<cr>", "Telescope LSP Implementations")
  keymap("n", "<leader>ts", "<cmd>Telescope lsp_document_symbols layout_strategy=vertical<cr>", "Telescope LSP Document Symbols")

  keymap("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, "LSP Add Workspace Folder")
  keymap("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, "LSP Remove Workspace Folder")
  keymap("n", "<leader>Wq", "<cmd>Trouble diagnostics toggle<cr>", "LSP Workspace Diagnostics")
  keymap("n", "<leader>Wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP Workspace List Folders")

  require("which-key").register({ ["<leader>g"] = "LSP Trouble" })
  require("which-key").register({ ["<leader>W"] = "LSP Workspace" })
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
  -- client capabilities object describing the LSP client capabilities
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- @perf: didChangeWatchedFiles is too slow
  -- @todo: Remove this when https://www.github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed
  local workarround_perf_fix = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    }
  }

  local capabilities = vim.tbl_deep_extend("force", {}, client_capabilities, lsp_capabilities, workarround_perf_fix)

  -- snippet support
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return capabilities
end

------------------------------------------------------------
-- LSP - navigation through method overloads
------------------------------------------------------------
LSP.overloads = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfigOverload", {}),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client.server_capabilities.signatureHelpProvider then
        require("lsp-overloads").setup(client, {
          silent = false,
          display_automatically = false,
          --- @diagnostic disable-next-line: missing-fields
          ui = {
            border = "solid",
            close_events = {
              "BufHidden",
              "CursorMoved", "CursorMovedI",
              "InsertLeave", "InsertEnter", "InsertChange",
              "TextChanged", "TextChangedI"
            },
          },
          keymaps = {
            next_signature = "<C-n>",
            previous_signature = "<C-p>",
            next_parameter = "<C-l>",
            previous_parameter = "<C-h>",
            close_signature = "<esc>"
          },
        })

        vim.keymap.set({ "n", "i" }, "<A-s>", "<cmd>LspOverloadsSignature<CR>", { silent = false });
        vim.keymap.set({ "n", "i" }, "<C-S-Space>", "<cmd>LspOverloadsSignature<CR>", { silent = false });
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
        diagnostics = { globals = { "vim" } },
        completion = { callSnippet = "Replace" },
        workspace = { checkThirdParty = "Disable" }
      }
    }
  })
end

------------------------------------------------------------
-- LSP dotnet - omnisharp
-- pacman -S [AUR] omnisharp-roslyn
-- pacman -S dotnet-runtime dotnet-sdk aspnet-runtime
-- https://github.com/omnisharp/omnisharp-roslyn
-- https://github.com/hoffs/omnisharp-extended-lsp.nvim
------------------------------------------------------------
LSP.setup_dotnet = function()
  local pid = vim.fn.getpid()
  local omnisharp_linux = "/usr/bin/omnisharp"
  local omnisharp_windows = "C:/dev/omnisharp-win-x64/OmniSharp.exe"
  local omnisharp_binary = is_windows and omnisharp_windows or omnisharp_linux

  require("lspconfig").omnisharp.setup({
    capabilities = LSP.capabilities(),
    cmd = { omnisharp_binary, "--languageserver" , "--hostPID", tostring(pid) },

    -- omnisharp extended handler
    handlers = {
      ["textDocument/definition"] = function(...)
        return require("omnisharp_extended").handler(...)
      end
    },

    -- Enables support for reading code style, naming convention and analyzer settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that were opened in the editor.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = true,

    -- Specifies whether "using" directives should be grouped and sorted during document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension methods in completion lists.
    enable_import_completion = true,

    -- Specifies whether to include preview versions of the .NET SDK when determining which version to use for project loading.
    sdk_include_prereleases = false,

    -- Only run analyzers against open files when "enableRoslynAnalyzers" is true
    analyze_open_documents_only = true,
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
    { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin LSP client
    { "issafalcon/lsp-overloads.nvim" }, -- extends the native nvim-lsp handlers to allow easier navigation through method overloads
  },
  config = function()
    LSP.init()
  end
}

-- init.lua, plugin development, signature help, docs and completion for the nvim lua api
Lazy.use {
  "folke/lazydev.nvim",
  dependencies = {{ "bilal2453/luvit-meta" }},
  ft = "lua",
  opts = {
    library = { "luvit-meta/library" }
  }
}

-- extend "textDocument/definition" handler for OmniSharp Neovim LSP
Lazy.use { "hoffs/omnisharp-extended-lsp.nvim" }

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
-- AutoComplete
-- hrsh7th/nvim-cmp
------------------------------------------------------------

local AutoComplete = {
  cmp = nil,
  snip = nil,

  opts = {
    border = "solid",
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
  }
}

AutoComplete.init = function()
  AutoComplete.cmp = require("cmp")
  AutoComplete.snip = require("luasnip")
end

AutoComplete.has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

AutoComplete.select_next_suggestion = function(fallback)
  local cmp = AutoComplete.cmp
  local snip = AutoComplete.snip

  if cmp == nil or snip == nil then
    error("AutoComplete: Missing CMP or LuaSnip.")
  end

  if cmp.visible() then
    cmp.select_next_item()
  elseif snip.expand_or_locally_jumpable() then
    snip.expand_or_jump()
  elseif AutoComplete.has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

AutoComplete.select_prev_suggestion = function(fallback)
  local cmp = AutoComplete.cmp
  local snip = AutoComplete.snip

  if cmp == nil or snip == nil then
    error("AutoComplete: Missing CMP or LuaSnip.")
  end

  if cmp.visible() then
    cmp.select_prev_item()
  elseif snip.jumpable(-1) then
    snip.jump(-1)
  else
    fallback()
  end
end

AutoComplete.setup = function()
  local cmp = AutoComplete.cmp
  local snip = AutoComplete.snip
  local border = AutoComplete.opts.border
  local winhighlight = AutoComplete.opts.winhighlight

  if cmp == nil or snip == nil then
    error("AutoComplete: Missing CMP or LuaSnip.")
  end

  cmp.setup({
    window = {
      completion = cmp.config.window.bordered({ border = border, winhighlight = winhighlight }),
      documentation = cmp.config.window.bordered({ border = border, winhighlight = winhighlight }),
    },
    completion = { completeopt = "menu,menuone,noselect" },
    experimental = { ghost_text = { hl_group = "LspCodeLens" } },
    snippet = {
      expand = function(args)
        snip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-a>"] = cmp.mapping.abort(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-c>"] = cmp.mapping.close(),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<A-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<A-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
      ["<S-CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ["<Tab>"] = cmp.mapping(AutoComplete.select_next_suggestion, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(AutoComplete.select_prev_suggestion, { "i", "s" }),
      ["<Up>"] = cmp.mapping(AutoComplete.select_prev_suggestion, { "i", "s" }),
      ["<Down>"] = cmp.mapping(AutoComplete.select_next_suggestion, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp_signature_help", priority = 64, group_index = 1 },
      { name = "nvim_lsp", priority = 32, group_index = 2 },
      { name = "nvim_lua", priority = 16, group_index = 3 },
      { name = "lazydev", priority = 12, group_index = 4 },
      { name = "luasnip", priority = 8, group_index = 4 },
      { name = "buffer", priority = 4, group_index = 5 },
      { name = "path", priority = 2, group_index = 6 },
    })
  })

  -- "/@" suggestions
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {{ name = "buffer" }},
      {{ name = "nvim_lsp_document_symbol" }}
    )
  })

  -- cmdline & path suggestions
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {{ name = "path" }},
      {{ name = "cmdline" }}
    )
  })
end

------------------------------------------------------------
-- Lazy AutoComplete setup
------------------------------------------------------------
Lazy.use {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-path" }, -- nvim-cmp source for path
    { "hrsh7th/cmp-buffer" }, -- nvim-cmp source for buffer words
    { "hrsh7th/cmp-cmdline" }, -- nvim-cmp source for vim's cmdline
    { "hrsh7th/cmp-nvim-lua" }, -- nvim-cmp source for neovim Lua API
    { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin lsp client
    { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- nvim-cmp source for displaying function signatures with the current parameter emphasized
    { "hrsh7th/cmp-nvim-lsp-document-symbol" }, -- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
    { "saadparwaiz1/cmp_luasnip" }, -- luasnip completion source for nvim-cmp
    { "l3mon4d3/luasnip" }, -- snippet engine -- TODO remove, use builtin snippet engine
  },
  config = function()
    AutoComplete.init()
    AutoComplete.setup()
  end
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

-- dismiss noice
local function close_noice()
  local is_noice_loaded = pcall(require, "noice")
  if is_noice_loaded then
    vim.cmd("Noice dismiss")
  end
end

-- escape fn
local function escape()
  close_noice()
  close_trouble()
  close_qf_loc_list()
  vim.cmd("fclose!")
end

-- map <esc> key
vim.keymap.set("n", "<esc>", escape, { silent = true, noremap = true, desc = "Escape" })

------------------------------------------------------------
-- NeoVide
------------------------------------------------------------

if vim.g.neovide then
  vim.opt.linespace = is_linux and 0 or 2
  vim.g.neovide_remember_window_size = true
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
-- LSP server configurations
--------------------------------------------------------------------------------
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/echasnovski/mini.nvim
-- https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
--------------------------------------------------------------------------------
