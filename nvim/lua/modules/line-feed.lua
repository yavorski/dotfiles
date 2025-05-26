------------------------------------------------------------
-- LF CMD
------------------------------------------------------------

-- Normalize Line Endings
-- Executing a command with : in visual line/block mode changes mode to normal mode, making it unclear what the previous mode was.
-- Checking the count option helps: -1 indicates "no range," implying the command was executed from normal mode (if only considering normal and visual modes).
local function normalize_line_endings(options)
  local cursor_position = vim.api.nvim_win_get_cursor(0)

  if options.count == -1 then
    vim.cmd("silent! keepalt keepjumps %s/\r//g")
  else
    vim.cmd("silent! keepalt keepjumps '<,'>s/\r//g")
  end

  vim.api.nvim_win_set_cursor(0, cursor_position)
end

-- user command
vim.api.nvim_create_user_command("NormalizeLineEndings", normalize_line_endings, { nargs = "?", range = "%", addr = "lines", desc = "Normalize Line Endings" })

-- Force convert file to LF
local function forcelf(options)
  local cursor_position = vim.api.nvim_win_get_cursor(0)
  vim.cmd("set fileformat=unix")
  normalize_line_endings(options)
  vim.api.nvim_win_set_cursor(0, cursor_position)
end

-- user command
vim.api.nvim_create_user_command("ForceLF", forcelf, { nargs = "?", range = "%", addr = "lines", desc = "Set LF Line Endings" })

-- Toggle Conceal CRLF ^M
local function toggle_conceal_crlf()
  if vim.wo.conceallevel > 0 then
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
    vim.cmd("syntax clear ExtraCR")
    vim.notify("Conceal CRLF -> OFF")
  else
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "n"
    vim.cmd("syntax match ExtraCR /\\r/ conceal")
    vim.notify("Conceal CRLF -> ON")
  end
end

-- user command
vim.api.nvim_create_user_command("ToggleConcealCRLF", toggle_conceal_crlf, { desc = "Toggle conceal of carriage return (^M) characters" })
