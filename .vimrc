" ------------------------------------------------------------
" [[ vim ]] - minimal configuration
" ------------------------------------------------------------

" Make Vim more useful
set nocompatible

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Show the filename in the window titlebar
set title

" Always show status line
set laststatus=2

" Enable syntax highlighting
syntax on

" Enable file type detection
filetype on

" Set bg dark/light
set background=dark

" enable 24-bit RGB colors
set termguicolors

" set color scheme
" colorscheme one
" colorscheme slate
colorscheme wildcharm

" Disable word wrap
set nowrap

" Enable line numbers
set number

" Highlight current line
set cursorline

" enable folding (default "foldmarker")
set foldmethod=marker

" intro / messages / hit-enter prompts / ins-completion-men
set shortmess=actIsoOFW

" signcolumn
set signcolumn=auto

" Enable mouse in all modes
" set mouse=a

" min number of screen lines above/below the cursor
set scrolloff=2

" vertical split to the right
set splitright

" system clipboard
set clipboard=unnamed,unnamedplus

" ignore case in search patterns
set ignorecase

" override the ignorecase option if the search containse upper characters
set smartcase

" Highlight searches
set hlsearch

" Highlight dynamically as pattern is typed
set incsearch

" complete menu
set completeopt=menu,menuone,noselect

" Reload file on external change
set autoread

" Backups
set nobackup
set noswapfile
set noundofile
set nowritebackup

" tabs indent
set tabstop=2     " 1 tab == 2 spaces
set shiftwidth=2  " indent is 2 spaces
set softtabstop=2 " insert 2 spaces when tab is pressed
set expandtab     " use spaces instead of tabs
set smartindent   " autoindent new lines

" Enhance command-line completion
set wildmenu

" Optimize for fast terminal connections
set ttyfast

" Don't reset cursor to start of line when moving around
set nostartofline

" Show the cursor position
set ruler

" Show the current mode
set showmode

" Show the (partial) command as it's being typed
set showcmd

" Don't add empty newlines at the end of binary files
set binary
set noeol

" Respect modeline in files
set modeline
set modelines=4

" Allow backspace in insert mode
set backspace=indent,eol,start

" If this many milliseconds nothing is typed the swap file will be written to disk
set updatetime=1024

" Allow cursor keys in insert mode
set esckeys

" list
set nolist
set listchars=eol:¬,tab:›-,trail:~,extends:»,precedes:«

" Adjust cursor blink rate
" Default is blinkwait700-blinkon400-blinkoff250
set guicursor=n:blinkwait1024-blinkon1024-blinkoff512

" ------------------------------------------------------------
" omni completion
" ------------------------------------------------------------
set omnifunc=syntaxcomplete#Complete

" ------------------------------------------------------------
" Pmenu
" ------------------------------------------------------------
highlight Pmenu ctermfg=White ctermbg=Black
highlight PmenuSel ctermfg=White ctermbg=Red
" ------------------------------------------------------------

" ------------------------------------------------------------
" Save a file as root (,W)
" ------------------------------------------------------------
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" ------------------------------------------------------------
" Visually select and press CTRL+C to yank to system clipboard
" ------------------------------------------------------------
vnoremap <C-c> "+y

" Use <C-L> to clear the highlighting of :set hlsearch.
" ------------------------------------------------------------
if maparg('<C-L>', 'n') ==# ''
	nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" ------------------------------------------------------------
" Automatic commands
" ------------------------------------------------------------
" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Rust
autocmd BufNewFile,BufRead *.rs setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
" ------------------------------------------------------------

" ------------------------------------------------------------
" wayland clipboard
" https://github.com/yavorski/vim-wayland-clipboard
" ------------------------------------------------------------
