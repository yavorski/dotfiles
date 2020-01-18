" Turn off GUI tabline
GuiTabline 0

" Turn off GUI completion menu
GuiPopupmenu 0

" Set GUI Font
" Guifont Source Code Pro:h10.42
Guifont Source Code Pro Medium:h8

" Pmenu
highlight Pmenu guifg=White guibg=Black
highlight PmenuSel guifg=White guibg=Red

" True color support
if (has("termguicolors"))
  set termguicolors
endif

" set color scheme
colorscheme molokai

" set 'one' bg to black
" call one#highlight('Normal', '', '010101', 'none')
