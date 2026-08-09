--- @brief
--- Rust debug adapter (codelldb)
--- https://aur.archlinux.org/packages/codelldb-bin
--- https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)

local dap = require("dap")

dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb", -- installed via AUR: codelldb-bin
}

--- Auto-detect the debug binary under target/debug when there's exactly one
--- candidate (directories/non-executables excluded), otherwise prompt for a
--- path (e.g. workspaces with multiple binaries).
local function pick_executable()
  local cwd = vim.fn.getcwd()
  local candidates = vim.fn.glob(cwd .. "/target/debug/*", false, true)
  candidates = vim.tbl_filter(function(path)
    return vim.fn.isdirectory(path) == 0 and vim.fn.executable(path) == 1
  end, candidates)

  if #candidates == 1 then
    return candidates[1]
  end

  return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
end

--- @type dap.Configuration[]
dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = pick_executable,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
    sourceLanguages = { "rust" }, -- enables codelldb's bundled Rust pretty-printers
  },
  {
    name = "Attach to process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceLanguages = { "rust" },
  },
}
