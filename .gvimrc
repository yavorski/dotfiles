" Use the Solarized Dark theme
set background=dark

if has('gui_running')
  let g:solarized_termcolors=256
else
  let g:solarized_termcolors=16
endif

colorscheme solarized

" Use 14pt Monaco
set guifont=Consolas:h14

" Better line-height
set linespace=8
