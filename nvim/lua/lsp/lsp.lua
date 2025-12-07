--- @brief
--- LSP servers/capabilities/keymaps setup/config
--- NOTE vim.lsp.document_color.enable() should be available in nvim v0.12

local vue = require("lsp/vue-tools")
local system = require("core/system")

--- @type table<string, vim.lsp.Config>
local servers = {
  cssls = {},
  taplo = {},
  bashls = {},
  jsonls = {},
  yamlls = {},
  pyrefly = {},
  terraformls = {},
  rust_analyzer = {},
  html = {
    filetypes = { "html", "cshtml", "razor", "htmlangular" }
  },
  emmet_language_server = {
    filetypes = { "html", "cshtml", "razor", "htmlangular" }
  },
  powershell_es = {
    bundle_path = system.is_windows and "C:/dev/ps-es-lsp" or "/opt/powershell-editor-services"
  }
}

servers["vtsls"] = vue.vtsls
servers["vue_ls"] = vue.vue_ls

servers["angularls"] = {
  filetypes = { "html", "htmlangular" },
  root_markers = { "angular.json" },
  workspace_required = true
}

servers["lua_ls"] = {
  settings = {
    Lua = {
      format = { enable = true },
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim", "require" } },
    }
  }
}

servers["azure_pipelines_ls"] = {
  filetypes = { "yaml" },
  root_markers = {
    "azure/",
    "pipelines/",
    "azure-cicd/",
    "azure-pipelines/",
  },
  workspace_required = true,
  settings = {
    yaml = {
      schemas = {
        [ "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json" ] = {
          -- "azure*.yml",
          "azure/*.yml",
          "*pipeline.yml",
          "pipelines/*.yml",
          "azure-cicd/*.yml",
          "azure-pipelines/*.yml",
        }
      }
    }
  }
}

--- lsp client capabilities
local function capabilities()
  -- client capabilities
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()

  -- additional capabilities
  local blink_lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

  -- @perf: didChangeWatchedFiles is too slow
  -- @todo: Remove this when https://www.github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed
  local workarround_perf_fix = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = false },
    }
  }

  return vim.tbl_deep_extend("force", {}, client_capabilities, blink_lsp_capabilities, workarround_perf_fix)
end

--- config and enable servers
local function setup_servers()
  vim.lsp.config("*", {
    capabilities = capabilities()
  })

  for server, options in pairs(servers) do
    vim.lsp.config(server, options or {})
    --- BUG ---
    --- use timeout as temporary fix
    --- neovim 0.11.2 not setting "filetype" on first opened buffer
    vim.schedule(function() vim.lsp.enable(server) end)
  end
end

--- delete default keymaps
local function del_default_keymaps()
  local function safe_del_keymap(mode, lhs)
    if vim.fn.mapcheck(lhs, mode) ~= "" then
      vim.keymap.del(mode, lhs)
    end
  end

  safe_del_keymap("n", "gra") -- actions
  safe_del_keymap("x", "gra") -- actions
  safe_del_keymap("n", "grn") -- rename
  safe_del_keymap("n", "grr") -- references
  safe_del_keymap("n", "gri") -- implementations
  safe_del_keymap("n", "grt") -- type definition
end

--- set buffer lsp keymaps
local function set_buffer_keymaps(buffer)
  -- enable completion triggered by <c-x><c-o>
  vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- key map fn
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = buffer, desc = desc, nowait = true })
  end

  -- vim.lsp.buf.references - default is <grr>
  keymap("n", "gr", "<cmd>FzfLua lsp_references<cr>", "LSP References")
  keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", "LSP References")

  -- vim.lsp.buf.definition
  keymap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "LSP Definition")

  -- vim.lsp.buf.declaration
  keymap("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "LSP Declaration")

  -- vim.lsp.buf.implementation - default is <gri>
  keymap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "LSP Implementation")

  -- vim.lsp.buf.type_definition - default is <grt>
  keymap("n", "g<space>", "<cmd>FzfLua lsp_typedefs<cr>", "LSP Type Definition")

  -- default is <grn>
  keymap({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, "LSP Rename")

  -- vim.lsp.buf.format with async = true
  keymap({ "n", "v" }, "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format")

  -- default is <K>
  -- keymap({ "n", "v" }, "K", vim.lsp.buf.hover, "LSP Hover")
  keymap({ "n", "v" }, "<leader>k", vim.lsp.buf.hover, "LSP Hover")

  -- default is <CTRL-s> in insert and select mode
  keymap({ "n", "v" }, "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")
  keymap({ "n", "x", "i", "s" }, "<C-s>", vim.lsp.buf.signature_help, "LSP Signature Help")

  -- default is <gra>
  keymap({ "n", "v" }, "<leader>A", vim.lsp.buf.code_action, "LSP Code Action") -- with preview
  keymap({ "n", "v" }, "<leader>a", "<cmd>FzfLua lsp_code_actions previewer=false winopts.row=0.25 winopts.width=0.7 winopts.height=0.42<cr>", "LSP Code Action") -- no preview

  -- toggle inlay hints
  keymap("n", "<leader>;", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, "LSP Toggle Inlay Hints")

  -- toggle view diagnostics
  keymap("n", "<leader>,", function()
    local c = vim.diagnostic.config()
    vim.diagnostic.config({
      virtual_text = not c.virtual_text and { current_line = true } or false,
      virtual_lines = not c.virtual_lines and { current_line = true } or false
    })
  end, "LSP Toggle diagnostics")

  -- diagnostics <CTRL-W-d> is default
  keymap("n", "<leader>e", vim.diagnostic.open_float, "LSP Diagnostic Float")
  keymap("n", "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", "LSP Document Diagnostics")
  keymap("n", "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", "LSP Workspace Diagnostics")

  -- workspace
  keymap("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, "LSP Add Workspace Folder")
  keymap("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, "LSP Remove Workspace Folder")
  keymap("n", "<leader>Wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP Workspace List Folders")
end

--- attach keymaps on LspAttach event
local function setup_keymaps()
  del_default_keymaps()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("usr-lsp-keymaps", { clear = true }),
    callback = function(event)
      set_buffer_keymaps(event.buf)
    end
  })
end

-- init settings and servers
local function init()
  setup_keymaps()
  setup_servers()
end

-- mod
return { init = init }
