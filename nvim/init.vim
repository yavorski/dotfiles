" Init NeoVim

" Make Vim more useful
set nocompatible
set termguicolors

" https://github.com/junegunn/vim-plug
" PlugInstall/PlugUpdate

call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'fatih/vim-go'
Plug 'nsf/gocode'
Plug 'junegunn/fzf'
Plug 'ryanoasis/vim-devicons' " https://github.com/ryanoasis/nerd-fonts is required

call plug#end()

" Theme options
syntax on
colorscheme one

let g:airline_theme='one'
let g:one_allow_italics=1
let g:airline_powerline_font=1

" let g:airline_theme='onedark'
" colorscheme onedark

set background=dark
" set background=light

" Better line height
" set linespace=8
" set guifont=Consolas
" set guifont="Operator Mono Medium"

" Enable line numbers
set number

" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=2

" Show "invisible" characters
" set list
" set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_

" NERDTree options
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <F4> :NERDTreeToggle<CR>

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

" Disable error bells
" set noerrorbells

" Change mapleader
" let mapleader=","

" Don't reset cursor to start of line when moving around
set nostartofline

" Show the cursor position
set ruler

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Show the (partial) command as it's being typed
set showcmd

" Don't add empty newlines at the end of files
set binary
set noeol

" Change default dir
cd ~/dev
