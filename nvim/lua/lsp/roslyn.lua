--- @brief
--- Microsoft.CodeAnalysis.LanguageServer

local Lazy = require("core/lazy")
local system = require("core/system")

--- @module "roslyn.config"
--- @type RoslynNvimConfig
local options = {
  filewatching = system.is_wsl and "off" or "auto",
}

Lazy.use {
  "seblyng/roslyn.nvim",
  ft = { "cs", "razor" },
  config = function()
    -- Setup LSP <cmd>
    vim.lsp.config("roslyn", {
      cmd = {
        "roslyn-language-server",
        "--logLevel=Information",
        "--stdio"
      }
    })
    -- Setup plugin
    require("roslyn").setup(options)
  end
}
