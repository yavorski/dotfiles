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

" should remap <tab> - in conflict with coc
" required for "vim-es6" and "YouCompleteMe"
" Plug 'SirVer/ultisnips'

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

" Autocomplete

" pacman -S nodejs npm
" pacman -S rust-analyzer
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" YCM not compatible with coc for the moment?
" Plug 'Valloric/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer --go-completer --rust-completer --ts-completer' }


call plug#end()
" ==============================================================


" Base Settings
" ==============================================================

" Enable syntax highlighting
syntax on
syntax enable

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

" Don't pass messages to ins-completion-menu
set shortmess+=c

" Centralize backups, swapfiles and undo history
" Never let Vim write a backup file! They did that in the 70's.
set nobackup
set noswapfile
set noundofile
set nowritebackup

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


" coc.nvim
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" ==============================================================

let cocs = []

" call add(cocs, 'coc-rls')
" call add(cocs, 'coc-rome')
call add(cocs, 'coc-clangd')
call add(cocs, 'coc-cmake')
call add(cocs, 'coc-css')
call add(cocs, 'coc-cssmodules')
call add(cocs, 'coc-go')
call add(cocs, 'coc-highlight')
call add(cocs, 'coc-html')
call add(cocs, 'coc-html-css-support')
call add(cocs, 'coc-json')
call add(cocs, 'coc-rust-analyzer')
call add(cocs, 'coc-sh')
call add(cocs, 'coc-snippets')
call add(cocs, 'coc-sql')
call add(cocs, 'coc-svg')
call add(cocs, 'coc-toml')
call add(cocs, 'coc-tsserver')
call add(cocs, 'coc-vimlsp')
call add(cocs, 'coc-xml')
call add(cocs, 'coc-yaml')

let g:coc_global_extensions = cocs
" ==============================================================

" coc.nvim setup
" https://github.com/neoclide/coc.nvim
" ==============================================================

" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin before putting this into your config
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" Mappings for CoCList
" ==============================================================

" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>

" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>

" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>

" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>

" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>

" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>

" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>

" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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
  filetype plugin indent on

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




" Troubleshoot
" ==============================================================
" :CocInfo
" :checkhealth
" :set cmdheight=2
" :set completeopt?
" :verbose set completeopt?
" :verbose imap <tab>
" ==============================================================
