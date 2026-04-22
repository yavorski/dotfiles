--- @brief
--- Microsoft.CodeAnalysis.LanguageServer
--- Use bin/roslyn-razor.sh to install/update (roslyn + razor extension)
--- Use bin/roslyn-update.sh to install/update (roslyn only)

local Lazy = require("core/lazy")
local system = require("core/system")

--- @type string
local logs = vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn-ls/logs")
local rdkdir = vim.fs.abspath(system.is_windows and "C:/dev/roslyn-razor" or "~/dev/roslyn-razor")
local roslyn_ls = vim.fs.joinpath(rdkdir, "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll")
local razor_compiler = vim.fs.joinpath(rdkdir, "razor", "Microsoft.CodeAnalysis.Razor.Compiler.dll")
local razor_design = vim.fs.joinpath(rdkdir, "razor", "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets")
local razor_extension = vim.fs.joinpath(rdkdir, "razor", "Microsoft.VisualStudioCode.RazorExtension.dll")

--- @module "roslyn.config"
--- @type RoslynNvimConfig
local options = {
  filewatching = system.is_wsl and "off" or "auto",
  -- Disable plugin's default razor extension resolution; we wire razor via `cmd` below.
  -- Avoids: "Extension 'razor' is enabled but no path was provided. Skipping..."
  extensions = {
    razor = {
      enabled = true,
      config = {
        path = razor_extension,
        args = {
          "--razorSourceGenerator=" .. razor_compiler,
          "--razorDesignTimePath=" .. razor_design,
        }
      }
    }
  }
}

Lazy.use {
  "seblyng/roslyn.nvim",
  ft = "cs",
  config = function()
    -- Override the default `cmd` from the plugin's `lsp/roslyn.lua` so the server
    -- launches via `dotnet <dll>` with the custom razor extension paths.
    vim.lsp.config("roslyn", {
      cmd = {
        "dotnet", roslyn_ls,
        "--logLevel", "Information",
        "--razorSourceGenerator", razor_compiler,
        "--razorDesignTimePath", razor_design,
        "--extension", razor_extension,
        "--extensionLogDirectory", logs,
        "--stdio"
      }
    })
    require("roslyn").setup(options)
  end
}
