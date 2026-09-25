--- @brief
--- Microsoft.CodeAnalysis.LanguageServer

local Lazy = require("core/lazy")
local system = require("core/system")
local roslyn_language_server = vim.fn.exepath("roslyn-language-server")

if roslyn_language_server == "" then
  roslyn_language_server = vim.fn.expand("~/.dotnet/tools/roslyn-language-server")
end

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
        roslyn_language_server,
        "--logLevel=Information",
        "--stdio"
      }
    })
    -- Setup plugin
    require("roslyn").setup(options)
  end
}
