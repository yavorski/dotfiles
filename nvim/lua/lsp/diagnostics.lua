------------------------------------------------------------
-- Diagnostics Config
------------------------------------------------------------

---@type vim.diagnostic.Opts
local options = {
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
}

-- Setup later to avoid sourcing `vim.diagnostic` on startup
vim.schedule(function() vim.diagnostic.config(options) end)
