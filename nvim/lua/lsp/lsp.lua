local system = require("core/system")
local window_border = require("core/border")

------------------------------------------------------------
-- LSP - setup
-- neovim/nvim-lspconfig
------------------------------------------------------------
local LSP = {}

--- @type table<string, vim.lsp.Config>
LSP.servers = {
  cssls = {},
  taplo = {},
  bashls = {},
  jsonls = {},
  yamlls = {},
  dockerls = {},
}

LSP.servers["html"] = {
  filetypes = { "html", "cshtml", "razor", "htmlangular" }
}

LSP.servers["emmet_language_server"] = {
  filetypes = { "html", "cshtml", "razor", "htmlangular" }
}

LSP.servers["angularls"] = {
  filetypes = { "html", "htmlangular" },
  root_markers = { "angular.json" },
  workspace_required = true
}

LSP.servers["lua_ls"] = {
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

LSP.servers["powershell_es"] = {
  bundle_path = system.is_windows and "C:/dev/ps-es-lsp" or "/opt/powershell-editor-services"
}

LSP.servers["azure_pipelines_ls"] = {
  filetypes = { "yaml" },
  root_markers = { "azure/", "pipelines/" },
  workspace_required = true,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "azure*.yml",
          "azure/*.yml",
          "*pipeline.yml",
          "pipelines/*.yml",
        }
      }
    }
  }
}

------------------------------------------------------------
-- LSP - setup listed servers
------------------------------------------------------------

LSP.setup_servers = function()
  vim.lsp.config("*", {
    capabilities = LSP.capabilities()
  })

  for server, options in pairs(LSP.servers) do
    vim.lsp.config(server, options or {})
    --- BUG ---
    --- use timeout as temporary fix
    --- neovim 0.11.2 not setting "filetype" on first opened buffer
    vim.schedule(function() vim.lsp.enable(server) end)
  end
end

------------------------------------------------------------
-- LSP - client capabilities
------------------------------------------------------------

LSP.capabilities = function()
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

  local capabilities = vim.tbl_deep_extend("force", {}, client_capabilities, blink_lsp_capabilities, workarround_perf_fix)

  return capabilities
end

------------------------------------------------------------
-- LSP - attach keymaps on LspAttach event
------------------------------------------------------------

LSP.keymaps = function()
  LSP.del_keymaps()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(event)
      LSP.buffer_keymaps(event.buf)
    end
  })
end

------------------------------------------------------------
-- LSP buffer keymaps
------------------------------------------------------------

-- delete defaults
LSP.del_keymaps = function()
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
end

-- set mappings
LSP.buffer_keymaps = function(buffer)
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

  -- vim.lsp.buf.type_definition
  keymap("n", "g<space>", "<cmd>FzfLua lsp_typedefs<cr>", "LSP Type Definition")

  -- default is <grn>
  keymap({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, "LSP Rename")

  -- vim.lsp.buf.format with async = true
  keymap({ "n", "v" }, "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format")

  -- default is <K>
  -- keymap({ "n", "v" }, "K", vim.lsp.buf.hover, "LSP Hover")
  keymap({ "n", "v" }, "<leader>k", vim.lsp.buf.hover, "LSP Hover")

  -- default is <CTRL-s> in insert mode
  keymap({ "n", "v" }, "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")
  keymap({ "n", "v", "i" }, "<C-s>", vim.lsp.buf.signature_help, "LSP Signature Help")

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
  keymap("n", "<leader>E", vim.diagnostic.open_float, "LSP Diagnostic Float")
  keymap("n", "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", "LSP Document Diagnostics")
  keymap("n", "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", "LSP Workspace Diagnostics")

  -- workspace
  keymap("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, "LSP Add Workspace Folder")
  keymap("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, "LSP Remove Workspace Folder")
  keymap("n", "<leader>Wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP Workspace List Folders")
end

------------------------------------------------------------
-- LSP - navigation through method overloads
------------------------------------------------------------

LSP.overloads = function()
  local function show_lsp_signature_overloads()
    require("blink.cmp.signature.trigger").hide()
    vim.cmd("LspOverloadsSignature");
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfigOverload", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client ~= nil and client.server_capabilities.signatureHelpProvider then
        require("lsp-overloads").setup(client, {
          silent = true,
          display_automatically = false,
          ui = { silent = true, border = window_border }, --- @diagnostic disable-line
          keymaps = { next_signature = "<A-n>", previous_signature = "<A-p>", close_signature = "<A-o>" } --- @diagnostic disable-line
        })

        vim.keymap.set({ "n", "i" }, "<A-o>", show_lsp_signature_overloads, { silent = true, desc = "LSP Overloads" });
      end
    end
  })
end

------------------------------------------------------------
-- LSP init settings and servers
-- NOTE -- vim.lsp.document_color.enable() -- nvim v0.12
------------------------------------------------------------

LSP.init = function()
  LSP.keymaps()
  LSP.overloads()
  LSP.setup_servers()
end

-- mod
return LSP
