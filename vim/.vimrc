" Init Vim

" Make Vim more useful
set nocompatible

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Manage plugins
" https://github.com/junegunn/vim-plug
" ==============================================================
call plug#begin('~/.vim/plugged')

" Airline
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Themes
Plug 'rakr/vim-one'
Plug 'rakr/vim-togglebg'
" Plug 'joshdick/onedark.vim'

" https://github.com/ryanoasis/nerd-fonts is required
" Plug 'ryanoasis/vim-devicons'

" Enable sidebar
Plug 'scrooloose/nerdtree'

" required for "vim-es6" and "YouCompleteMe"
Plug 'SirVer/ultisnips'

" Go plugins
" Plug 'nsf/gocode'
" Plug 'fatih/vim-go'

" Better json
Plug 'elzr/vim-json'

" EcmaScript syntax
Plug 'isRuslan/vim-es6'

" Emmet plugin
Plug 'mattn/emmet-vim'

" HTML Match Tag
Plug 'Valloric/MatchTagAlways'

" Handlebars syntax highlighting
Plug 'mustache/vim-mustache-handlebars'

" Stylus syntax highlight
Plug 'iloginow/vim-stylus'

" Fast file navigation
Plug 'wincent/command-t'

" Search
Plug 'junegunn/fzf', { 'dir': '~/.config/vim/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Autocomplete
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --clangd-completer --ts-completer' }

call plug#end()
" ==============================================================


" UI Settings
" ==============================================================

" Enable syntax highlighting
syntax on

" Set UI color scheme
colorscheme one

" Set bg dark/light
set background=dark

" Set airline options
let g:airline_theme='one'
let g:one_allow_italics=1
let g:airline_powerline_fonts=1

" airline theme
" let g:airline_theme='onedark'

" Set line-height
" set linespace=8

" Set font-family
" set guifont="Source Code Pro"
" set guifont="Operator Mono Medium"

" Set conceal to false in elzr/vim-json
let g:vim_json_syntax_conceal=0

" Enable line numbers
set number

" Highlight current line
set cursorline

" Use the OS clipboard by default
set clipboard=unnamed " Mac OS
set clipboard=unnamedplus " Linux

" Enhance command-line completion
set wildmenu

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
set gdefault

" Highlight searches
set hlsearch

" Highlight dynamically as pattern is typed
set incsearch

" Ignore case of searches
set ignorecase

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=a

" Don't reset cursor to start of line when moving around
set nostartofline

" Start scrolling three lines before the horizontal window border
set scrolloff=2

" Show the cursor position
set ruler

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

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

" Disable error bells
" set noerrorbells

" Don't show the intro message when starting Vim
set shortmess=atI

" Centralize backups, swapfiles and undo history
" Never let Vim write a backup file! They did that in the 70's.
set nobackup
set noswapfile

" Make tabs as wide as two spaces
set tabstop=2
set shiftwidth=2
set expandtab
" set smarttab
" set autoindent
" set softtabstop=2

" Show "invisible" characters
set nolist
set listchars=eol:¬,tab:›-,trail:·,extends:»,precedes:«
"set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<,space:␣


" NERDTree options
" ==============================================================
" autocmd vimenter * NERDTree
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeAutoDeleteBuffer=1

" (▸ ▾), (▹, ▿), (› ⬎), (❯ ━), (❱ ━), (✚ ━), (+ -), (→ ↓), (↱ ↴), (➙ ➘), (⤻ ⤹)
let g:NERDTreeDirArrowExpandable = '→'
let g:NERDTreeDirArrowCollapsible = '➘'

map <F4> :NERDTreeToggle<CR>
" ==============================================================


" Change <Leader> key
" It is mapped to backslash "\" by default
" ==============================================================
" let mapleader=","

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Visually select and press CTRL+C to yank to system clipboard
vnoremap <C-c> "+y

" Allow cursor keys in insert mode
if !has('nvim')
  set esckeys
endif


" Trim trailing whitespace (,ss)
" ==============================================================
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

" noremap <leader>tw :call TrimWhitespace()<CR>
" ==============================================================


" Automatic commands
" ==============================================================
if has("autocmd")
  " Enable file type detection
  filetype on

  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

  " Trim trailing whitespace on save
  autocmd BufWritePre * :call TrimWhitespace()
endif


" Change current dir to ~/dev
" ==============================================================
cd ~/dev
