--- @brief
--- @module "nvim-treesitter"
--- npm i -g tree-sitter-cli
--- pacman -S tree-sitter-cli
--- checkhealth nvim-treesitter
--- install_dir = "~/.local/share/nvim/site"
--- nvim --headless +TSInstallParsersSync +qa!
--- nvim --headless +"Lazy load nvim-treesitter" +TSInstallParsersSync +qa!

--- TODO Incremental Selection
--- incremental_selection = { keymaps = { init_selection = "<C-space>", node_incremental = "<C-space>", node_decremental = "<bs>", scope_incremental = false } }

local Lazy = require("core/lazy")

local parsers = {
  "angular",
  "bash",
  "c_sharp",
  "cmake",
  -- "comment",
  "css",
  "csv",
  "desktop",
  "diff",
  "dockerfile",
  "dtd", --> ( xml )
  "ecma",
  "editorconfig",
  "embedded_template", --> ( html ejs, erb )
  "fish",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "glimmer", --> ( html handlebars )
  "glimmer_javascript",
  "glimmer_typescript",
  "html",
  "html_tags",
  "http",
  "hyprlang",
  "ini",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "jsx",
  -- "lua",
  -- "luadoc",
  -- "luap",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "passwd",
  "pem",
  "php",
  "powershell",
  "pug",
  "python",
  "query",
  "razor",
  "regex",
  "robots",
  "rust",
  "scss",
  "sql",
  "ssh_config",
  "styled",
  "terraform",
  "tmux",
  "toml",
  "tsv",
  "tsx",
  "typescript",
  "udev",
  "vue",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "zathurarc",
  "zig",
}

Lazy.use {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  -- event = "BufRead",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()
    -- require("nvim-treesitter").install(parsers)
  end,
  init = function()
    vim.treesitter.language.register("bash", "kitty")
    vim.treesitter.language.register("ini", "ghostty")
  end
}

--- Toggle TS
local function toggle_tree_sitter()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[bufnr] ~= nil then
    vim.treesitter.stop(bufnr)
    vim.notify("Disable tree-sitter")
  else
    vim.treesitter.start(bufnr)
    vim.notify("Enable tree-sitter")
  end
end

--- Toggle keymap
vim.keymap.set("n", "<leader>T", toggle_tree_sitter, { silent = true, desc = "Toggle tree-sitter" })

--- User commands
vim.api.nvim_create_user_command("TSBufToggle", toggle_tree_sitter, { desc = "Toggle tree-sitter" })
vim.api.nvim_create_user_command("TSBufEnable", function() vim.treesitter.start() end, { desc = "Start tree-sitter" })
vim.api.nvim_create_user_command("TSBufDisable", function() vim.treesitter.stop() end, { desc = "Stop tree-sitter" })
vim.api.nvim_create_user_command("TSInstallParsers", function() require("nvim-treesitter").install(parsers) end, { desc = "Install tree-sitter specified parsers" })

--- Install parsers sync
vim.api.nvim_create_user_command(
  "TSInstallParsersSync",
  function()
    require("nvim-treesitter").install(parsers, { summary = true }):wait(5 * 60 * 1000)
  end,
  { desc = "Install tree-sitter specified parsers sync" }
)

--- Start tree-sitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("enable-tree-sitter", { clear = true }),
  callback = function(args)
    local bufnr = args.buf;
    local buffer = vim.bo[bufnr]

    -- Skip special buffers
    if buffer.buftype ~= "" then return end

    -- Execute once per buffer
    if vim.b[bufnr].treesitter_initialized then return end

    local ok, _ = pcall(vim.treesitter.start, bufnr)

    if ok then
      -- folds, provided by Neovim
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      -- indentation, provided by nvim-treesitter -- LUA/HTML/YAML issues?
      -- buffer.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

      -- set indentation for python
      if buffer.filetype == "python" then
        buffer.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
      end
    end

    if not ok and buffer.filetype == "conf" then
      ok, _ = pcall(vim.treesitter.start, bufnr, "ini")
    end

    if not ok then
      vim.defer_fn(function()
        vim.notify("Missing tree-sitter parser for filetype: " .. buffer.filetype, vim.log.levels.ERROR)
      end, 100)
    end

    vim.b[bufnr].treesitter_initialized = true
  end
})
