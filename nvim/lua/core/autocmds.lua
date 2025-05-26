------------------------------------------------------------
-- Auto CMD
------------------------------------------------------------

-- enable all filetype plugins
-- vim.cmd[[filetype plugin indent on]]

-- enable syntax highlighting
-- if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

-- trim trailing whitespace on save
-- vim.cmd[[autocmd BufWritePre * :%s/\s\+$//e]]

-- use tabs
vim.cmd[[autocmd FileType make setlocal noexpandtab]]

-- disable sign column
vim.cmd[[autocmd FileType help setlocal signcolumn=no]]

-- disable relative numbers
vim.cmd[[autocmd FileType qf,lhelp,lquickfix,dbout setlocal norelativenumber]]

-- don't auto comment new lines
vim.cmd[[autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o]]

-- highlight on yank
vim.cmd[[autocmd TextYankPost * silent! lua vim.hl.on_yank({ higroup = "YankHighlight" })]]

-- 2 spaces for selected filetypes
vim.cmd[[autocmd FileType xml,html,css,json,lua,yaml,markdown setlocal shiftwidth=2 tabstop=2 expandtab]]

-- fix htmlangular indentation with =
vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmlangular",
  callback = function()
    vim.bo.indentexpr = ""
    vim.cmd[[runtime! indent/html.vim]]
  end
})
