" ------------------------------------------------------------
" [[ vim ]] - minimal config
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
filetype plugin on

" Set bg dark/light
set background=dark

" Enable 24-bit RGB colors
set termguicolors

" Set color scheme
colorscheme wildcharm

" Disable word wrap
set nowrap

" Enable line numbers
set number

" Highlight current line
set cursorline
set cursorlineopt=number

" Enable folding (default "foldmarker")
set foldmethod=marker

" intro / messages / hit-enter prompts / ins-completion-men
set shortmess=actIsoOFW

" signcolumn
set signcolumn=yes

" Enable mouse in all modes
" set mouse=a

" Min number of screen lines above/below the cursor
set scrolloff=2

" Vertical split to the right
set splitright

" System clipboard
set clipboard=unnamed,unnamedplus

" Ignore case in search patterns
set ignorecase

" Override the ignorecase option if the search containse upper characters
set smartcase

" Highlight searches
set hlsearch

" Highlight dynamically as pattern is typed
set incsearch

" complete menu
set completeopt=menu,menuone,noselect,fuzzy

" Enhance command-line completion
set wildmenu

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
" Omni Completion
" ------------------------------------------------------------
set omnifunc=syntaxcomplete#Complete

" ------------------------------------------------------------
" Pmenu
" ------------------------------------------------------------
highlight Pmenu guibg=#07070c
highlight PmenuSbar guibg=#181825
highlight PmenuThumb guibg=#94e2d5

" ------------------------------------------------------------
" Automatic commands
" ------------------------------------------------------------

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Fix indent
autocmd BufNewFile,BufRead *.md setlocal ts=2 sw=2 sts=2 noet

" ------------------------------------------------------------
" Leader
" ------------------------------------------------------------
let mapleader = " "
let maplocalleader = " "

" ------------------------------------------------------------
" Keymaps
" ------------------------------------------------------------

" Disable 'm' marks key
nnoremap <silent> m <Nop>
vnoremap <silent> m <Nop>
xnoremap <silent> m <Nop>

" Clear hlsearch
nnoremap <silent> <C-L> :nohlsearch<CR>

" Visual yank to system clipboard
" Wayland clipboard -> yavorski/vim-wayland-clipboard
vnoremap <C-c> "+y
vnoremap <leader>Y "+y

" Buffers
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>e :bwipout<CR>

" Save as root
noremap <leader>W :w !sudo tee % > /dev/null 2>&1<CR>

" Match brackets using 'mm' (Matchit plugin)
packadd! matchit
nnoremap <silent> mm <Plug>(MatchitNormalForward)
vnoremap <silent> mm <Plug>(MatchitVisualForward)
xnoremap <silent> mm <Plug>(MatchitVisualForward)

" ------------------------------------------------------------
" FZF
" ------------------------------------------------------------

let g:fzf_layout = { 'window': { 'width': 0.85, 'height': 0.85, 'yoffset': 0.4, 'border': 'sharp' } }
let g:fzf_preview = '--preview-window=right:51% --preview-border=left --preview="bat --number --color=always {}"'
let g:fzf_keymaps = '--bind="ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up"'
let g:fzf_options = '--cycle --layout=reverse ' . g:fzf_preview . ' ' . g:fzf_keymaps
let g:fzf_buffers = '--prompt="Buffers> " ' . g:fzf_options
let $FZF_DEFAULT_OPTS = g:fzf_options

function! FzfBuffers()
  let l:buffers = map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)')
  call fzf#run({ 'source': l:buffers, 'sink': 'e', 'options': g:fzf_buffers , 'window': g:fzf_layout['window'] })
endfunction

command! FzfBuffers call FzfBuffers()

nnoremap <silent> <leader>f <cmd>FZF<CR>
nnoremap <silent> <leader>b :FzfBuffers<CR>
