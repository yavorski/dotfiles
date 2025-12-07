------------------------------------------------------------
-- [[ neovim ]] -- [[ settings ]] --
------------------------------------------------------------

-- title filename
vim.opt.title = true

-- hide cmd line
vim.opt.cmdheight = 0

-- show status line
vim.opt.laststatus = 3

-- show tab line
vim.opt.showtabline = 2

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
vim.opt.relativenumber = false

-- highlight line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
if vim.wo.diff then vim.opt.cursorlineopt = "both" end

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
vim.opt.sidescrolloff = 16

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
  tab = "🡲 ",
  trail = "~",
  space = "∙",
}

------------------------------------------------------------
-- Folds -> vim.opt.statuscolumn = "%C%s%l "
-- tree-sitter folds in plugins/tree-sitter
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

------------------------------------------------------------
-- grep/vimgrep/ripgrep
------------------------------------------------------------

-- default grep program
-- vim.opt.grepprg = "grep -n $* /dev/null"

-- use ripgrep instead of grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --follow"

------------------------------------------------------------
-- Disable providers
-- Set `0` to disable providers
------------------------------------------------------------

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-----------------------------------------------------------------------------
-- Disable built in plugins
-- Set `1` to mark them as "already loaded", so neovim will skip loading them
-----------------------------------------------------------------------------

vim.g.loaded_gzip = 1
vim.g.loaded_tutor = 1
vim.g.loaded_tohtml = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

------------------------------------------------------------
-- Filetypes Auto Detection
------------------------------------------------------------

vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
    tf = "terraform"
  },
  pattern = {
    [ "kitty.conf" ] = "kitty",
    [ ".*/waybar/config" ] = "jsonc",
    [ ".*/ghostty/config" ] = "ghostty",
    [ ".*/hypr/.*%.conf" ] = "hyprlang",
  }
})
