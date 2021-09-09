" Turn off GUI tabline
GuiTabline 0

" Turn off GUI completion menu
GuiPopupmenu 0

" Set GUI Font
" Guifont Fira Mono:h8.32:b
" Guifont Source Code Pro:h10.42
" Guifont Source Code Pro Medium:h8
Guifont Source Code Pro:h10:b

" Pmenu
highlight Pmenu guifg=White guibg=Black
highlight PmenuSel guifg=White guibg=Red

" True color support
if (has("termguicolors"))
  set termguicolors
endif

