--- @brief
--- Microsoft.CodeAnalysis.LanguageServer
--- Use bin/roslyn-update.sh to install/update

local Lazy = require("core/lazy")
local system = require("core/system")

--- @module "roslyn.config"
--- @type RoslynNvimConfig
local options = { }

--- @type string
local roslyn = "Microsoft.CodeAnalysis.LanguageServer.dll"

Lazy.use {
  "seblyng/roslyn.nvim",
  ft = "cs",
  config = function()
    vim.lsp.config("roslyn", {
      cmd = {
        "dotnet",
        system.is_windows and "C:/dev/roslyn/" .. roslyn or vim.fs.abspath("~/.local/share/nvim/roslyn/" .. roslyn),
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio"
      }
    })
    require("roslyn").setup(options)
  end
}
