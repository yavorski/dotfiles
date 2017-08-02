" INIT NEOVIM
" /{user}/AppData/Local/nvim

set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc
" source ~/.gvimrc
set termguicolors

" Use the Solarized Dark theme

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme solarized

" Use 14pt Monaco
set guifont=Consolas

" Better line-height
set linespace=8
