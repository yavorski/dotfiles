--- @brief
--- https://github.com/microsoft/vscode-js-debug/releases/latest
--- JavaScript / TypeScript debug adapter (vscode-js-debug via `dapDebugServer.js`)
--- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript

local dap = require("dap")

-- Path to the extracted js-debug-dap release (dapDebugServer.js)
local js_debug_path = vim.fn.expand("~/.local/bin/js-debug/src/dapDebugServer.js")

-- Single vscode-js-debug server handles both Node ("pwa-node") and Chrome ("pwa-chrome") sessions.
for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
  dap.adapters[adapter] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = { js_debug_path, "${port}" },
    },
  }
end

--- Prompt for an npm script to run under the debugger
local function npm_script()
  return vim.fn.input("npm run-script: ", "", "shellcmd")
end

--- @type dap.Configuration[]
local node_configurations = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch npm run-script",
    runtimeExecutable = "npm",
    runtimeArgs = function() return { "run-script", npm_script() } end,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
  },
}

-- TypeScript can't run directly via `node`, so run it through ts-node instead.
-- Requires `ts-node` to be resolvable from `cwd` (e.g. installed as a devDependency).
--- @type dap.Configuration[]
local ts_configurations = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file (ts-node)",
    program = "${file}",
    cwd = "${workspaceFolder}",
    runtimeArgs = { "-r", "ts-node/register" },
    sourceMaps = true,
    resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
    skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch npm run-script",
    runtimeExecutable = "npm",
    runtimeArgs = function() return { "run-script", npm_script() } end,
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
  },
}

--- Browser debugging (React/Vue/etc). Assumes a dev server is already running.
--- `webRoot` assumes the dev server serves "${workspaceFolder}" at "/".
--- If a project serves from a subfolder (e.g. "public/"), override `webRoot` via a project-local ".vscode/launch.json".
--- It is auto-loaded by nvim-dap, no dap.lua changes needed.
--- @type dap.Configuration[]
local chrome_configurations = {
  {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome (port 9222)",
    port = 9222,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome against localhost",
    url = function() return vim.fn.input("URL: ", "http://localhost:3000") end,
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
  },
}

dap.configurations.javascript = {
  unpack(node_configurations),
  unpack(chrome_configurations)
}

dap.configurations.javascriptreact = {
  unpack(node_configurations),
  unpack(chrome_configurations)
}

dap.configurations.typescript = {
  unpack(ts_configurations),
  unpack(chrome_configurations)
}

dap.configurations.typescriptreact = {
  unpack(ts_configurations),
  unpack(chrome_configurations)
}
