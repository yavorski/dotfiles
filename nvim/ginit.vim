" Turn off GUI tabline
GuiTabline 0

" Turn off GUI completion menu
GuiPopupmenu 0

" Set GUI Font
" Guifont Fira Mono:h8.32:b
" Guifont Source Code Pro:h10.42
" Guifont Source Code Pro:h8.4:b
Guifont Source Code Pro Medium:h8

" Pmenu
highlight Pmenu guifg=White guibg=Black
highlight PmenuSel guifg=White guibg=Red

" True color support
if (has("termguicolors"))
  set termguicolors
endif

" set color scheme
" colorscheme molokai
" let g:molokai_original=1

colorscheme gruvbox
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_improved_strings=1
let g:gruvbox_improved_warnings=1
let g:gruvbox_italicize_strings=1
let g:gruvbox_contrast_dark='hard'

" set 'one' bg to black
" call one#highlight('Normal', '', '010101', 'none')
