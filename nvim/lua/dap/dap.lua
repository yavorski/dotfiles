--- @brief
--- Core debug adapter protocol (DAP) client for Neovim

local Lazy = require("core/lazy")

-- Breakpoint signs
local function set_signs()
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine", numhl = "" })
end

local keys = {
  { "<F5>", function() require("dap").continue() end, desc = "DAP Continue/Start" },
  { "<F8>", function() require("dap").continue() end, desc = "DAP Continue/Start" },
  { "<S-F5>", function() require("dap").terminate() end, desc = "DAP Terminate" },
  { "<F17>", function() require("dap").terminate() end, desc = "DAP Terminate" },
  { "<C-F5>", function() require("dap").restart() end, desc = "DAP Restart" },
  { "<F29>", function() require("dap").restart() end, desc = "DAP Restart" },
  { "<F6>", function() require("dap").pause() end, desc = "DAP Pause" },
  { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
  { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
  { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
  { "<S-F11>", function() require("dap").step_out() end, desc = "DAP Step Out" },
  { "<F23>", function() require("dap").step_out() end, desc = "DAP Step Out" },
  { "<C-S-F9>", function() require("dap").clear_breakpoints() end, desc = "DAP Clear All Breakpoints" },
  { "<F45>", function() require("dap").clear_breakpoints() end, desc = "DAP Clear All Breakpoints" },
  { "<leader>K", "<cmd>DapViewHover<CR>", desc = "DAP View Hover" },
  { "<C-F12>", "<cmd>DapViewToggle<CR>", desc = "DAP Toggle Dap View" },
  -- { "<leader>Bl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP Log Point", },
  -- { "<leader>Bc", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP Conditional Breakpoint", },
}


Lazy.use {
  "mfussenegger/nvim-dap",
  dependencies = {
    "igorlfs/nvim-dap-view"
  },
  keys = keys,
  config = function()
    set_signs()
    require("dap/adapters/js")
    require("dap/adapters/rust")
    require("dap/adapters/dotnet")
  end
}
