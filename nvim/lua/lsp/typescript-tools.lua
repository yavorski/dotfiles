local Lazy = require("core/lazy")

--- @diagnostic disable: missing-fields
local ts_tools_config = {
  -- capabilities = LSP.capabilities(), -- ?

  --- @module "typescript-tools.config"
  settings = {
    -- locale of all tsserver messages
    tsserver_locale = "en",

    -- memory limit in megabytes or "auto" - basically no limit
    tsserver_max_memory = "auto",

    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = true,

    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
    publish_diagnostic_on = "insert_leave",

    -- fn completion
    complete_function_calls = true,
    include_completions_with_insert_text = true,

    --- specify commands exposed as code_actions, "all" to expose all available
    --- @diagnostic disable-next-line: assign-type-mismatch
    expose_as_code_action = "all",

    -- ts preferences
    tsserver_file_preferences = {
      quotePreference = "auto",
      includeInlayVariableTypeHints = true,
      includeInlayParameterNameHints = "all",
      includeInlayFunctionLikeReturnTypeHints = true,
    }
  }
}

-- LSP TypeScript TS Server
Lazy.use {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  event = {
    "BufReadPre *.ts,*.tsx,*.js,*.jsx,*.mjs",
    "BufNewFile *.ts,*.tsx,*.js,*.jsx,*.mjs"
  },
  opts = ts_tools_config
}
