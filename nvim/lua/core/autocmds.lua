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

-- fix indentation with =
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("local/indent", {}),
  pattern = { "razor", "cshtml", "htmlangular" },
  callback = function()
    vim.bo.indentexpr = ""
    vim.cmd[[runtime! indent/html.vim]]
  end
})

-- fix matchit in razor files
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("local/match", {}),
  pattern = { "razor", "cshtml" },
  callback = function()
    -- Load matchit plugin first
    if not vim.g.loaded_matchit then
      vim.cmd[[runtime! plugin/matchit.vim]]
    end

    -- Load HTML ftplugin to get proper HTML tag matching
    if not vim.b.did_ftplugin then
      vim.cmd[[runtime! ftplugin/html.vim]]
    end
  end
})

-- stop on dashes when using "w"
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("local/styles", {}),
  pattern = { "css", "less", "sass", "scss", "stylus" },
  callback = function()
    vim.opt_local.iskeyword:remove("-")
  end
})

-- notify start macro recording
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = vim.api.nvim_create_augroup("local/recording-start", {}),
  callback = function()
    local reg = vim.fn.reg_recording()
    vim.notify(string.format("Recording @%s", reg), vim.log.levels.INFO)
  end,
})

-- notify stop macro recording
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = vim.api.nvim_create_augroup("local/recording-stop", {}),
  callback = function()
    vim.notify("Recording stopped", vim.log.levels.INFO)
  end,
})
