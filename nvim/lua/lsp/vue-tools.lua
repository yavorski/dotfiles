--- Root directory function for VitePress projects (vue_ls and vtsls)
--- Only attaches in .vitepress projects
--- For markdown SFC files, only attaches if inside docs/ folder
--- @param bufnr number
--- @param on_dir function
local function vitepress_root_dir(bufnr, on_dir)
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- start only with .vitepress
  if not vim.fs.root(bufnr, { ".vitepress" }) then
    return
  end

  -- exclude deno
  -- if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" }) then
  --   return
  -- end

  -- For markdown files specifically, only attach if inside docs/ folder
  if vim.bo[bufnr].filetype == "markdown" and not bufname:match("/docs/") then
    return
  end

  local root_markers = { "package.json", "package-lock.json" }

  -- Fallback to current working directory if no project root is found
  local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

  on_dir(project_root)
end

--- vue_ls for dedicated Vue.js support (templates, directives)
--- Works alongside vtsls for complete Vue development experience
--- @type vim.lsp.Config
local vue_ls = {
  init_options = {
    typescript = {
      tsdk = ""  -- Will auto-detect local project typescript
    }
  },
  filetypes = {
    "vue",
    "markdown"
  },
  root_dir = vitepress_root_dir
}

--- vtsls with Vue support via @vue/typescript-plugin
--- Handles TypeScript/JavaScript intelligence in .vue files
--- @type vim.lsp.Config
local vtsls = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = "usr/lib/node_modules/@vue/language-server",
            languages = { "vue", "markdown" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          }
        }
      }
    }
  },
  filetypes = {
    "vue",
    "markdown"
  },
  root_dir = vitepress_root_dir
}

return {
  vtsls = vtsls,
  vue_ls = vue_ls,
}
