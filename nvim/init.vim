" Init NeoVim

" Make Vim more useful
set nocompatible

" Use UTF-8 without BOM
" set encoding=utf-8 nobomb

" Manage plugins
" https://github.com/junegunn/vim-plug
" ==============================================================
call plug#begin('~/.config/nvim/plugged')

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Color scheme
Plug 'rakr/vim-one'
Plug 'tomasr/molokai'
Plug 'ciaranm/inkpot'
Plug 'morhetz/gruvbox'
Plug 'trusktr/seti.vim'

" Enable sidebar
Plug 'scrooloose/nerdtree'

" Show git status in nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'

" Shows a git diff in the gutter (sign column) and stages/undoes hunks
Plug 'airblade/vim-gitgutter'

" required for "vim-es6" and "YouCompleteMe"
Plug 'SirVer/ultisnips'

" Better json
Plug 'elzr/vim-json'

" EcmaScript syntax
Plug 'isRuslan/vim-es6'

" Vastly improved Javascript indentation and syntax support in Vim
Plug 'pangloss/vim-javascript'

" Handlebars syntax highlighting
Plug 'mustache/vim-mustache-handlebars'

" Stylus syntax highlight
Plug 'iloginow/vim-stylus'

" Emmet plugin
Plug 'mattn/emmet-vim'

" Filetype plugin for csv files
Plug 'chrisbra/csv.vim'

" quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'Raimondi/delimitMate'
Plug 'jiangmiao/auto-pairs'

" Comment stuff out
Plug 'tpope/vim-commentary'

" enable repeating supported plugin maps with "."
Plug 'tpope/vim-repeat'

" HTML5 omnicomplete and syntax
Plug 'othree/html5.vim'

" HTML Match Tag
Plug 'Valloric/MatchTagAlways'

" Change an HTML opening tag and take the closing one along as well
Plug 'AndrewRadev/tagalong.vim'

" Toggle, display and navigate marks
Plug 'kshenoy/vim-signature'

" True Sublime Text style multiple selections for Vim
Plug 'terryma/vim-multiple-cursors'

" A Vim alignment plugin
Plug 'junegunn/vim-easy-align'

" Text filtering and alignment
Plug 'godlygeek/tabular'

" Fast file navigation
" Plug 'wincent/command-t'
Plug 'ctrlpvim/ctrlp.vim'

" Search Ag/Rg
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" Autocomplete
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --clangd-completer --go-completer --rust-completer --ts-completer' }


call plug#end()
" ==============================================================


" Base Settings
" ==============================================================

" Enable syntax highlighting
syntax on

" Set UI color scheme
colorscheme one

" Set bg dark/light
set background=dark

" Set line-height
" set linespace=8

" Set font-family
" set guifont="Source Code Pro"
" set guifont="Operator Mono Medium"

" Enable line numbers
set number

" Highlight current line
set cursorline

" Adjust cursor blink rate
" Default is blinkwait700-blinkon400-blinkoff250
set guicursor=n:blinkwait1024-blinkon1024-blinkoff512

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

" Disable word wrap
set nowrap

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
set noundofile

" If this many milliseconds nothing is typed the swap file will be written to disk
" Also used for vim-gitgutter timeout
" Also used for the CursorHold autocommand event
set updatetime=256

" Make tabs as wide as two spaces
set tabstop=2
set shiftwidth=2
set expandtab
" set smarttab
" set autoindent
" set softtabstop=2

" Allow cursor keys in insert mode
if !has('nvim')
  set esckeys
endif

" Show "invisible" characters
set nolist
set listchars=eol:¬,tab:›-,trail:·,extends:»,precedes:«


" Use ripgrep instead of grep
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow

" Use the current working directory (cwd) for ripgrep
" let g:rg_derive_root='true'
" ==============================================================


" Pmenu
" ==============================================================
highlight Pmenu ctermfg=White ctermbg=Black
highlight PmenuSel ctermfg=White ctermbg=Red
" ==============================================================


" Change <Leader> key
" ==============================================================
" It is mapped to backslash "\" by default
" let mapleader=","

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Visually select and press CTRL+C to yank to system clipboard
vnoremap <C-c> "+y
" ==============================================================




" Env Settings
" ==============================================================


" Python 2
" ==============================================================
let g:python_host_prog = '/usr/bin/python2'
" ==============================================================


" Python 3
" ==============================================================
let g:python3_host_prog = '/usr/bin/python3'
" ==============================================================




" Plugin Settings
" ==============================================================


" FZF & CTRL-T
" ==============================================================
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git'"
let $FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND"
" ==============================================================


" Airline config
" ==============================================================
let g:airline_theme='simple'
let g:airline_powerline_fonts=0
" ==============================================================


" rakr/vim-one config
" ==============================================================
let g:one_allow_italics=1
" ==============================================================


" elzr/vim-json config
" ==============================================================
" Set conceal to false in elzr/vim-json
let g:vim_json_syntax_conceal=0
" ==============================================================


" NerdTree config
" ==============================================================
" Enter nerdtree
" autocmd VimEnter * NERDTree

let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeAutoDeleteBuffer=1

let g:NERDTreeDirArrowExpandable = '→'
let g:NERDTreeDirArrowCollapsible = '↓'

" Toggle nerdtree
map <F4> :NERDTreeToggle<CR>

" Refresh nerdtree
map <F5> :NERDTreeRefreshRoot<CR>

" Reveal in nerdtree <Ctlr+Alt+R>
map <F8> :NERDTreeFind<CR>
map <C-A-r> :NERDTreeFind<CR>


" NERDTree set file colors
function! NT_set_file_color(extension, fg, bg, guifg, guibg)
  exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

" NERDTree set file colors
call NT_set_file_color('sh', 'green', 'none', '#ffa500', '#151515')
call NT_set_file_color('sh*', 'green', 'none', '#ffa500', '#151515')

call NT_set_file_color('ini', 'yellow', 'none', 'yellow', '#151515')
call NT_set_file_color('conf', 'yellow', 'none', 'yellow', '#151515')
call NT_set_file_color('config', 'yellow', 'none', 'yellow', '#151515')

call NT_set_file_color('md', 'red', 'none', '#3366FF', '#151515')
call NT_set_file_color('html', 'white', 'none', 'yellow', '#151515')

call NT_set_file_color('css', 'magenta', 'none', 'red', '#151515')
call NT_set_file_color('styl', 'magenta', 'none', 'magenta', '#151515')

call NT_set_file_color('ts', 'cyan', 'none', '#ffa500', '#151515')
call NT_set_file_color('js', 'cyan', 'none', '#ffa500', '#151515')
call NT_set_file_color('mjs', 'cyan', 'none', '#ffa500', '#151515')

call NT_set_file_color('yml', 'yellow', 'none', 'yellow', '#151515')
call NT_set_file_color('json', 'yellow', 'none', 'yellow', '#151515')

call NT_set_file_color('vim', 'cyan', 'none', '#ffa500', '#151515')
" ==============================================================================


" nerdtree-git-plugin config
" ==============================================================
" Set nerdtree-git-plugin symbols ✨ ✗ ✘
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ "Modified"  : "*",
  \ "Staged"    : "+",
  \ "Untracked" : "-",
  \ "Renamed"   : "~",
  \ "Unmerged"  : "=",
  \ "Deleted"   : "×",
  \ "Dirty"     : "*",
  \ "Clean"     : "✓",
  \ 'Ignored'   : '!',
  \ "Unknown"   : "?"
  \ }
" ==============================================================


" ctrlpvim/ctrlp.vim config
" ==============================================================
" exclude custom files
let g:ctrlp_custom_ignore='\v[\/]\.(git|hg|svn)$'

" exclude .gitignore files
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" ==============================================================


" YCM conf
" ==============================================================
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
" ==============================================================


" Rust Racer AutoComplete conf
" ==============================================================
" set hidden
" let g:racer_cmd = "/home/user/.cargo/bin/racer"
" let g:racer_experimental_completer = 1
" let g:racer_insert_paren = 1
" ==============================================================




" Local Functions
" ==============================================================


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

  " .rafi syntax highlight
  autocmd BufNewFile,BufRead *.rasi setlocal filetype=css

  " Treat .md files as Markdown
  autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

  " Rust
  autocmd BufNewFile,BufRead *.rs setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

  " Trim trailing whitespace on save
  autocmd BufWritePre * :call TrimWhitespace()
endif
" ==============================================================
