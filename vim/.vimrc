" Init Vim

" Make Vim more useful
set nocompatible

" Manage plugins
" PlugInstall/PlugUpdate
" https://github.com/junegunn/vim-plug

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-togglebg'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/Command-T'
Plug 'SirVer/ultisnips'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'Valloric/YouCompleteMe'
Plug 'fatih/vim-go'
Plug 'nsf/gocode'
Plug 'junegunn/fzf'
Plug 'Valloric/MatchTagAlways'
Plug 'elzr/vim-json'
Plug 'isRuslan/vim-es6'
Plug 'ryanoasis/vim-devicons' " https://github.com/ryanoasis/nerd-fonts is required

call plug#end()

" Theme options

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

" colorscheme onedark
" let g:airline_theme='onedark'

" Set line-height
" set linespace=8

" Set font-family
" set guifont="Operator Mono Medium"

" Enable line numbers
set number

" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=2

" Show "invisible" characters
set list
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_


" NERDTree options
" autocmd vimenter * NERDTree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <F4> :NERDTreeToggle<CR>


" Typing
" Use the OS clipboard by default
set clipboard=unnamed

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
set scrolloff=3

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

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Centralize backups, swapfiles and undo history
" Never let Vim write a backup file! They did that in the 70's.
set nobackup
set noswapfile


" Remap =>

" Change <Leader> key
" It is mapped to backslash "\" by default
" let mapleader=","

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Visually select and press CTRL+C to yank to system clipboard
vnoremap <C-c> "+y

" Change default dir
cd ~/dev


" VIM ONLY =>

" Allow cursor keys in insert mode
if !has('nvim')
  set esckeys
endif


" Strip trailing whitespace (,ss)
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>


" Automatic commands
if has("autocmd")
  " Enable file type detection
  filetype on
  " Treat .json files as .js
  autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif
