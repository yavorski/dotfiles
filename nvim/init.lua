------------------------------------------------------------
-- [[ init.lua ]] --
------------------------------------------------------------

-- title filename
vim.opt.title = true

-- syntax highlighting
vim.opt.syntax = "enable"

-- dark/light
vim.opt.background = "dark"

-- enable 24-bit RGB colors
vim.opt.termguicolors = true

-- set colorscheme
-- vim.cmd[[colorscheme zephyr]]

-- disable word wrap
vim.opt.wrap = false

-- show line number
vim.opt.number = true

-- highlight current line
vim.opt.cursorline = true

-- enable folding (default "foldmarker")
vim.opt.foldmethod = "marker"

-- intro / hit-enter prompts / ins-completion-menu
vim.opt.shortmess = "actI"

-- line lenght marker
-- vim.opt.colorcolumn = "115"

-- signcolumn
vim.opt.signcolumn = "auto"

-- enable mouse
vim.opt.mouse = "a"

-- min number of screen lines above/below the cursor
vim.opt.scrolloff = 4

-- vertical split to the right
vim.opt.splitright = true

-- system clipboard
vim.opt.clipboard = "unnamedplus"

-- ignore case in search patterns
vim.opt.ignorecase = true

-- override the "ignorecase" option if the search containse upper characters
vim.opt.smartcase = true

-- complete menu
vim.opt.completeopt = "menu,menuone,noselect"

-- backups
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.writebackup = false

-- tabs, indent
vim.opt.tabstop = 2           -- 1 tab == 2 spaces
vim.opt.shiftwidth = 2        -- indent is 2 spaces
vim.opt.softtabstop = 2       -- insert 2 spaces when tab is pressed
vim.opt.expandtab = true      -- use spaces instead of tabs
vim.opt.smartindent = true    -- autoindent new lines

-- list
vim.opt.list = false
vim.opt.listchars = { space = "_", eol = "↲", tab = "⇁🢒", trail = "~" }

-----------------------------------------------------------
-- grep/vimgrep/ripgrep
-----------------------------------------------------------

-- default grep program
-- vim.opt.grepprg = "grep -n $* /dev/null"

-- use ripgrep instead of grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --follow"

-----------------------------------------------------------
-- Leader
-----------------------------------------------------------

-- <Leader>
-- vim.g.mapleader = [[\]]      -- Default is "\"
-- vim.g.maplocalleader = [[\]] -- Default is "\"

-----------------------------------------------------------
-- Rust
-----------------------------------------------------------

-- rust respect user settings
vim.g.rust_recommended_style = 0

-- rust reset "expandtab" so we can use "hard tabs"
vim.cmd[[autocmd FileType rust setlocal noexpandtab]]

-----------------------------------------------------------
-- edit cmd
-----------------------------------------------------------

-- remove whitespace on save
vim.cmd[[au BufWritePre * :%s/\s\+$//e]]

-- don't auto comment new lines
vim.cmd[[au BufEnter * set fo-=c fo-=r fo-=o]]

-- highlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)

-- disable indentline for markdown files (avoid concealing)
-- vim.cmd[[autocmd FileType markdown let g:indentLine_enabled=0]]

-- remove line lenght marker for selected filetypes
-- vim.cmd[[autocmd FileType text,markdown,xml,html,xhtml,javascript setlocal cc=0]]

-- 2 spaces for selected filetypes
-- vim.cmd[[autocmd FileType xml,html,xhtml,css,scss,javascript,json,lua,yaml setlocal shiftwidth=2 tabstop=2]]

-----------------------------------------------------------
-- Buffer navigation @todo
-----------------------------------------------------------

vim.api.nvim_set_keymap("n", "gb", "<cmd>bnext<cr>", { noremap = true, silent = true })

-----------------------------------------------------------
-- Packer
-----------------------------------------------------------
-- ~/.cache/nvim
-- ~/.local/share/nvim/site/pack/packer/
-- ~/.config/nvim/plugin/packer_compiled.lua
-----------------------------------------------------------

-- clone/install packer if it does not exist
-- this will happen only once when nvim is started on machine for the first time
local function install_packer_if_needed()
  local fn = vim.fn
  local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end

  return false
end

-- install packer and set a flag to use later
-- should we do packer sync later if needed for first time
local should_packer_sync = install_packer_if_needed()

-- use a protected call so we don't error out on first time use
local packer_loaded, packer = pcall(require, "packer")

-- do not process futher configuration if packer is not loaded
if not packer_loaded then
  return "! -> installing packer close and reopen neovim"
end

-- setup packer
packer.startup(function()
  local use = packer.use

  -- packer
  use { "wbthomason/packer.nvim" }

  -- colorscheme
  use {
    "glepnir/zephyr-nvim",
    requires = { "nvim-treesitter/nvim-treesitter", opt = true },
    config = function()
      require("zephyr")
    end
  }

  -- nvim dev icons
  use {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = false -- globally enable default icons (default to false)
      })
    end
  }

  -- statusline
  use {
    "hoob3rt/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup({
        options = {
          theme = "onedark",
          icons_enabled = true,
          section_separators = "", -- disable separators
          component_separators = "", -- disable separators
        },
        sections = {
          lualine_c = { "filename", "filesize" } -- display filesize near filename
        }
      })
    end
  }

  -- tabline
  use {
    "kdheepak/tabline.nvim",
    requires = {
      { "hoob3rt/lualine.nvim" },
      { "kyazdani42/nvim-web-devicons", opt = true}
    },
    config = function()
      require("tabline").setup({
        enable = true,
        options = {
        -- If lualine is installed tabline will use separators configured in lualine by default.
        -- These options can be used to override those settings.
          section_separators = { "", "" }, -- disable separators
          component_separators = { "", "" }, -- disable separators
          max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
          show_tabs_always = true, -- this shows tabs only when there are more than one tab or if the first tab is named
          show_devicons = false, -- this shows devicons in buffer section
          show_bufnr = true, -- this appends [bufnr] to buffer section -- buffer number
          show_filename_only = false, -- shows base filename only instead of relative path in filename
          modified_icon = "^ ", -- change the default modified icon
          modified_italic = false, -- set to true by default; this determines whether the filename turns italic if modified
          show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
        }
      })

      vim.cmd[[
        set guioptions-=e " Use showtabline in gui vim
        set sessionoptions+=tabpages,globals " store tabpages and globals in session
      ]]

      -- show only tab associated buffers
      -- https://github.com/kdheepak/tabline.nvim/issues/14#issuecomment-1181342696
      local tabline = require('tabline')
      local augroup = vim.api.nvim_create_augroup("TablineBuffers", {})

      local function show_only_tab_associated_buffers()
        local data = vim.t.tabline_data
        if data == nil then
          tabline._new_tab_data(vim.fn.tabpagenr())
          data = vim.t.tabline_data
        end
        data.show_all_buffers = false
        vim.t.tabline_data = data
        vim.cmd([[redrawtabline]])
      end

      vim.api.nvim_create_autocmd({ "TabEnter" }, {
        group = augroup,
        callback = show_only_tab_associated_buffers,
      })
    end
  }

  -- file explorer tree written in lua
  use {
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.api.nvim_set_keymap("n", "<leader>kb", "<cmd>lua require('nvim-tree').toggle()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>kr", "<cmd>lua require('nvim-tree').refresh()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>kf", "<cmd>lua require('nvim-tree').find_file()<cr>", { noremap = true, silent = true })
    end
  }

  -- git status signs
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end
  }

  -- show marks in the sign column
  use {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({})
    end
  }

  -- shows keybindings in popup
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end
  }

  -- autopairs for neovim written by lua
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  }

  -- auto close/rename html tag
  -- should load after treesitter
  use {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  }

  -- stylus support - outdated
  -- use { "iloginow/vim-stylus" }

  -- multiple cursors - very slow
  -- use { "mg979/vim-visual-multi" }

  -- emmet html/css/js/lorem
  use {
    "mattn/emmet-vim",
    config = function()
      vim.api.nvim_set_var("user_emmet_mode", "a") --//-- enable all functions in all modes
    end
  }

  -- find, filter, preview, pick
  -- highly extendable fuzzy finder over lists -> :Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          file_ignore_patterns = { ".git", "node_modules" },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden"
          }
        },
        pickers = {
          find_files = {
            hidden = true
          }
        }
      })

      -- load telescope-fzf-native.nvim
      require("telescope").load_extension("fzf")

      -- set key bindings
      vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>rg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>th", "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true, silent = true })
    end
  }

  -- tree-sitter is a parser generator tool and an incremental parsing library
  -- tree-sitter can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited
  use {
    "nvim-treesitter/nvim-treesitter",
    -- run = ":TSUpdate", -- https://github.com/wbthomason/packer.nvim/issues/1050
    run = function()
      if vim.fn.exists(":TSUpdate") == 2 then
        vim.cmd(":TSUpdate")
      end
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
          enable = true -- false will disable the extension
        },
        indent = {
          enable = true -- indentation based on treesitter for the = operator
        }
      })
    end
  }

  -- LSP - configurations for neovim"s built-in language server client
  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "rust-lang/rust.vim" }, -- vim configuration for rust.
      { "simrat39/rust-tools.nvim" }, -- tools for better development in rust using neovim"s builtin lsp - adds extra functionality over rust analyzer
      { "sumneko/lua-language-server" }, -- lua language server coded by lua
      { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin LSP client
    },
    config = function()
      setup_lsp()
    end
  }

  -- AutoComplete
  use {
    "hrsh7th/nvim-cmp", -- completion plugin for neovim coded in lua
    requires = {
      { "hrsh7th/cmp-path" }, -- nvim-cmp source for path
      { "hrsh7th/cmp-buffer" }, -- nvim-cmp source for buffer words
      { "hrsh7th/cmp-cmdline" }, -- nvim-cmp source for vim"s cmdline
      { "hrsh7th/cmp-nvim-lua" }, -- nvim-cmp source for neovim Lua API
      { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin lsp client
      { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- nvim-cmp source for displaying function signatures with the current parameter emphasized
      { "saadparwaiz1/cmp_luasnip" }, -- luasnip completion source for nvim-cmp
      { "L3MON4D3/LuaSnip" } -- snippet engine for neovim written in lua
    },
    config = function()
      setup_autocomplete()
    end
  }

  -- Should be at the end after all plugins
  -- Automatically set up your configuration after cloning packer.nvim
  if should_packer_sync then
    packer.sync()
  end
end)


-----------------------------------------------------------
-- LSP
-- neovim/nvim-lspconfig
-----------------------------------------------------------
-- Documentation
-- https://langserver.org/
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
-- https://microsoft.github.io/language-server-protocol/implementors/servers/
-----------------------------------------------------------
function setup_lsp()
  local nvim_lsp = require("lspconfig")

  local on_attach = function(client, bufnr)
    -- enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }

    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "g<space>", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gn", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>qq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>er", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)

    -- list lsp document symbols in telescope
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lds", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>]], opts)

    -- vim.cmd [[ command! Format execute "lua vim.lsp.buf.formatting()" ]]
  end

  -- nvim-cmp supports additional completion capabilities
  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- enable the following language servers
  -- call "setup" on multiple servers and map buffer local keybindings when the language server attaches
  local servers = {
    "html",
    "cssls",
    "gopls",
    "jsonls",
    "bashls",
    "clangd",
    "pyright",
    "tsserver",
    "dockerls",
    -- "rust_analyzer",
    -- "lua-language-server",
  }

  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  -----------------------------------------------------------
  -- rust_analyzer lsp server
  -- simrat39/rust-tools.nvim
  -----------------------------------------------------------
  require("rust-tools").setup({
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  })

  -----------------------------------------------------------
  -- lua lsp server
  -- sumneko/lua-language-server
  -----------------------------------------------------------
  local sumneko_bin = vim.fn.exepath("lua-language-server")
  local sumneko_root = vim.fn.stdpath("data").."/site/pack/packer/start/lua-language-server"

  nvim_lsp.sumneko_lua.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { sumneko_bin, "-E", sumneko_root .. "/main.lua" },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT", -- LuaJIT in case of Neovim
          path = vim.split(package.path, ";") -- setup lua path
        },
        diagnostics = {
          globals = {
            "vim" -- recognize the `vim` global from LS
          }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        },
        telemetry = {
          enable = false
        }
      }
    }
  })
end


-----------------------------------------------------------
-- AutoComplete
-- hrsh7th/nvim-cmp
-----------------------------------------------------------
function setup_autocomplete()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        select = true,
        behavior = cmp.ConfirmBehavior.Replace,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = {
      -- { name = "cmdline" },
      { name = "path" },
      { name = "buffer" },
      { name = "luasnip" },
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
    }
  })
end


-------------------------------------------------------------------------------
-- Required in path
-------------------------------------------------------------------------------
-- pacman -S gcc pyright rust-analyzer lua-language-server gopls
-- pacman -S fd ripgrep curl tar nodejs tree-sitter ttf-nerd-fonts-symbols-mono

-- npm i -g typescript
-- npm i -g typescript-language-server
-- npm i -g vscode-langservers-extracted
-- npm i -g bash-language-server
-- npm i -g dockerfile-language-server-nodejs
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Troubleshoot
-------------------------------------------------------------------------------
-- :Rust
-- :LspInfo
-- :Telescope
-- :checkhealth
-- :set cmdheight=2
-- :set completeopt?
-- :verbose imap <tab>
-- :verbose set completeopt?
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
