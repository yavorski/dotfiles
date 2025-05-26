------------------------------------------------------------
-- Diagnostics Config
------------------------------------------------------------

vim.diagnostic.config({
  underline = false,
  severity_sort = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = { current_line = true },
  signs = {
    text = {
      [ vim.diagnostic.severity.HINT ] = "★",
      [ vim.diagnostic.severity.INFO ] = "▪",
      [ vim.diagnostic.severity.WARN ] = "◮",
      [ vim.diagnostic.severity.ERROR ] = "",
    }
  }
})
