--- @brief
--- .NET Core debug adapter (netcoredbg)
--- https://aur.archlinux.org/packages/netcoredbg-bin
--- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#dotnet

local dap = require("dap")

dap.adapters.coreclr = {
  type = "executable",
  command = "netcoredbg", -- installed via AUR: netcoredbg-bin
  args = { "--interpreter=vscode" },
}

--- Auto-detect the built .dll under bin/Debug/**/ when there's exactly one
--- candidate matching the project name (derived from a .csproj in cwd),
--- otherwise prompt for a path (e.g. multi-project solutions or when the
--- project name can't be determined).
local function pick_dll()
  local cwd = vim.fn.getcwd()
  local candidates = vim.fn.glob(cwd .. "/bin/Debug/**/*.dll", false, true)

  -- Narrow down to dlls matching the project name, so dependency dlls
  -- pulled into bin/Debug (e.g. via NuGet) don't get picked up.
  local csproj = vim.fn.glob(cwd .. "/*.csproj", false, true)[1]
  if csproj then
    local project_name = vim.fn.fnamemodify(csproj, ":t:r")
    candidates = vim.tbl_filter(function(path)
      return vim.fn.fnamemodify(path, ":t:r") == project_name
    end, candidates)
  end

  if #candidates == 1 then
    return candidates[1]
  end

  return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
end

--- @type dap.Configuration[]
dap.configurations.cs = {
  {
    name = "Launch",
    type = "coreclr",
    request = "launch",
    program = pick_dll,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to process",
    type = "coreclr",
    request = "attach",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}
