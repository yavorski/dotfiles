------------------------------------------------------------
-- [[ neovim ]] [[ init.lua ]] --
------------------------------------------------------------

-- title filename
vim.opt.title = true

-- hide cmd line
vim.opt.cmdheight = 0

-- show status line only in active window
vim.opt.laststatus = 1

-- syntax highlighting
vim.opt.syntax = "enable"

-- dark/light
vim.opt.background = "dark"

-- enable 24-bit RGB colors
vim.opt.termguicolors = true

-- set colorscheme
-- vim.cmd[[colorscheme zephyr]]
-- vim.cmd[[colorscheme dark-knight]]

-- disable word wrap
vim.opt.wrap = false

-- show line number
vim.opt.number = true

-- highlight current line
vim.opt.cursorline = true

-- enable folding (default "foldmarker")
vim.opt.foldmethod = "marker"

-- intro / messages / hit-enter prompts / ins-completion-menu
vim.opt.shortmess = "actIsoOFW"

-- line lenght marker
-- vim.opt.colorcolumn = "128"

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

-- reload file on external change
vim.opt.autoread = true

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

-----------------------------------------------------------
-- Reset "expandtab" in order to use "hard tabs"
-----------------------------------------------------------

vim.cmd[[autocmd FileType ps1 setlocal noexpandtab]]
vim.cmd[[autocmd FileType rust setlocal noexpandtab]]

-----------------------------------------------------------
-- list
-----------------------------------------------------------
vim.opt.list = false
vim.opt.listchars = { space = "_", eol = " ", tab = "» ", trail = "~" }

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
-- Rust
-----------------------------------------------------------

-- rust respect user settings
vim.g.rust_recommended_style = 0

-----------------------------------------------------------
-- Buffer navigation
-----------------------------------------------------------

-- standard prev/next
vim.keymap.set("n", "gbn", "<cmd>bnext<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gbp", "<cmd>bprev<cr>", { noremap = true, silent = true })

-- require nvim-lualine/lualine.nvim plugin
vim.keymap.set("n", "gb1", "<cmd>LualineBuffersJump! 1<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb2", "<cmd>LualineBuffersJump! 2<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb3", "<cmd>LualineBuffersJump! 3<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb4", "<cmd>LualineBuffersJump! 4<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb5", "<cmd>LualineBuffersJump! 5<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb6", "<cmd>LualineBuffersJump! 6<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb7", "<cmd>LualineBuffersJump! 7<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb8", "<cmd>LualineBuffersJump! 8<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb9", "<cmd>LualineBuffersJump! 9<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb0", "<cmd>LualineBuffersJump! 10<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "gb$", "<cmd>LualineBuffersJump $<cr>", { noremap = true, silent = true })

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
    vim.cmd[[packadd packer.nvim]]
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

-- config
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end
  }
})

-- setup plugins
packer.startup(function()
  local use = packer.use

  -- packer
  use { "wbthomason/packer.nvim" }

  -- delete buffers without losing window layout
  use {
    "famiu/bufdelete.nvim",
    config = function()
      -- override built in bd
      vim.cmd[[cabbrev bd Bdelete]]
      vim.cmd[[cabbrev bdelete Bdelete]]
    end
  }

  -- colorscheme
  use {
    -- "~/dev/dark-knight-nvim",
    "yavorski/dark-knight-nvim",
    requires = { "nvim-treesitter/nvim-treesitter", opt = true },
    config = function()
      require("dark-knight").setup({})
      vim.cmd.colorscheme("dark-knight")
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
    "nvim-lualine/lualine.nvim", -- statusline plugin
    -- after = "dark-knight-nvim", -- init after color scheme in order to prevent any overrides
    requires = {
      { "tiagovla/scope.nvim" }, -- scope buffers to tabs
      { "kyazdani42/nvim-web-devicons", opt = true }, -- use dev icons
      { "whoissethdaniel/lualine-lsp-progress.nvim" }, -- display lsp progress
      { "yavorski/lualine-lsp-client-name.nvim" }, -- display lsp client name
    },
    config = function()
      require("scope").setup()

      require("lualine").setup({
        options = {
          theme = "dark-knight", -- "onedark"
          icons_enabled = true,
          section_separators = "", -- disable separators
          component_separators = "", -- disable separators
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename", "filesize", "lsp_progress" },
          lualine_x = { "searchcount", "lsp_client_name", "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" }
        },
        tabline = {
          lualine_a = {{
            "buffers",
            mode = 0, -- shows only buffer name
            icons_enabled = false, -- disable icons for tabline
            show_filename_only = true,
            show_modified_status = true,
            hide_filename_extension = false,
            max_length = vim.o.columns, -- maximum width of buffers component
            symbols = {
              modified = " ^", -- buffer is modified
              directory = "", -- buffer is a directory
              alternate_file = "#", -- text for alternate file
            },
            filetype_names = {
              fzf = "FZF",
              alpha = "Alpha",
              packer = "Packer",
              NvimTree = "NvimTree",
              dashboard = "Dashboard",
              TelescopePrompt = "Telescope",
            },
          }},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "tabs" }
        },
        extensions = { "nvim-tree" }
      })

      require("lualine").refresh()
    end
  }

  -- file explorer tree written in lua
  use {
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        update_focused_file = {
          enable = true
        }
      })
      vim.keymap.set("n", "<leader>kb", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>kr", "<cmd>NvimTreeRefresh<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>kf", "<cmd>NvimTreeFindFile<cr>", { noremap = true, silent = true })
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
      require("marks").setup({
        mappings = {
          next = "<F2>", -- alacritty
          prev = "<F14>", -- <Shift>+<F2>
        }
      })
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

  -- color highlighter/display hex colors
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "vim", "lua", "css", "sass", "scss", "stylus", "html", "yml", "yaml", "markdown", "javascript", "typescript"
      })
    end
  }

  -- polyglot - don't play along with tree-sitter
  -- use { "sheerun/vim-polyglot" }

  -- stylus syntax
  use { "wavded/vim-stylus" }

  -- razor syntax
  use {
    "adamclerk/vim-razor",
    config = function()
      vim.api.nvim_create_augroup("Razor", { clear = true })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { group = "Razor", pattern = { "*.razor", "*.cshtml" }, command = "setlocal filetype=razor" })
    end
  }

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
      -- { "nvim-telescope/telescope-fzf-native.nvim", run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
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
            "--hidden",
            "--trim"
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
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>p", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>rg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>th", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { noremap = true, silent = true })
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
          enable = true, -- false will disable the extension
          -- additional_vim_regex_highlighting = false -- setting to true will run `:h syntax` and tree-sitter at the same time
        },
        indent = {
          enable = true -- indentation based on treesitter for the = operator
        }
      })
    end
  }

  -- tree-sitter playground
  use {
    "nvim-treesitter/playground",
		after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true
        }
      })
    end
  }

  -- nvim-treesitter-textobjects -- syntax aware text-objects, select, move, swap, and peek support
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- visual mode
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>sw"] = "@parameter.inner" },
            swap_previous = { ["<leader>sW"] = "@parameter.inner" },
          },
        }
      })
    end
  }

  -- LSP - configurations for neovim's built-in language server client
  use {
    "neovim/nvim-lspconfig",
    requires = {
      { "rust-lang/rust.vim" }, -- vim configuration for rust.
      { "simrat39/rust-tools.nvim" }, -- tools for better development in rust using neovim's builtin lsp - adds extra functionality over rust analyzer
      { "sumneko/lua-language-server" }, -- lua language server coded by lua
      { "hoffs/omnisharp-extended-lsp.nvim" }, -- extend "textDocument/definition" handler for OmniSharp Neovim LSP
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
      { "hrsh7th/cmp-cmdline" }, -- nvim-cmp source for vim's cmdline
      { "hrsh7th/cmp-nvim-lua" }, -- nvim-cmp source for neovim Lua API
      { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin lsp client
      { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- nvim-cmp source for displaying function signatures with the current parameter emphasized
      { "hrsh7th/cmp-nvim-lsp-document-symbol" }, -- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
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
-- https://microsoft.github.io/language-server-protocol/implementors/servers/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
------------------------------------------------------------------------------------
function setup_lsp()
  local nvim_lsp = require("lspconfig")

  local on_attach = function(client, bufnr)
    -- enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }

    -- keybindings
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "g<space>", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ff", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>ff", "<cmd>lua vim.lsp.buf.format()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "v", "<leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>qq", "<cmd>lua vim.diagnostic.setloclist()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>er", "<cmd>lua vim.diagnostic.open_float({ border = 'solid' })<cr>", opts)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)

    -- lsp with telescope
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tp", "<cmd>Telescope diagnostics<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tr", "<cmd>Telescope lsp_references<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>td", "<cmd>Telescope lsp_definitions<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ti", "<cmd>Telescope lsp_implementations<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ts", "<cmd>Telescope lsp_document_symbols<cr>", opts)
  end

  -- nvim-cmp supports additional completion capabilities
  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
    "emmet_ls",
    -- "powershell"
    -- "rust_analyzer",
    -- "omnisharp-roslyn",
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

  nvim_lsp.lua_ls.setup({
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

  -----------------------------------------------------------
  -- dotnet omnisharp
  -- pacman -S dotnet-runtime dotnet-sdk aspnet-runtime
  -- pacman AUR -S omnisharp-roslyn
  -- https://github.com/omnisharp/omnisharp-roslyn
  -- https://github.com/hoffs/omnisharp-extended-lsp.nvim
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#omnisharp
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/omnisharp.lua
  ---------------------------------------------------------------------------------------------------------
  local pid = vim.fn.getpid()
  local omnisharp_bin = "/usr/bin/omnisharp"
  local omnisharp_extended = require("omnisharp_extended")

  nvim_lsp.omnisharp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },

    -- omnisharp extended handler
    handlers = {
      ["textDocument/definition"] = omnisharp_extended.handler,
    },

    -- Enables support for reading code style, naming convention and analyzer settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that were opened in the editor.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = true,

    -- Specifies whether "using" directives should be grouped and sorted during document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension methods in completion lists.
    enable_import_completion = false,

    -- Specifies whether to include preview versions of the .NET SDK when determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when "enableRoslynAnalyzers" is true
    analyze_open_documents_only = true,
  })

  -----------------------------------------------------------
  -- powershell
  -- pacman AUR -S powershell-bin powershell-editor-services
  -- https://aur.archlinux.org/packages/powershell-bin
  -- https://aur.archlinux.org/packages/powershell-editor-services
  -- https://github.com/powershell/powershelleditorservices
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#powershell_es
  --------------------------------------------------------------------------------------------------
  nvim_lsp.powershell_es.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    -- bundle_path = "C:/dev/ps-es-lsp",
    bundle_path = "/opt/powershell-editor-services",
  })

  -----------------------------------------------------------
  -- borders
  -- single double rounded solid shadow none
  -----------------------------------------------------------
  local windows = require("lspconfig.ui.windows")
  windows.default_options.border = "solid";

  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "solid" })
end


-----------------------------------------------------------
-- AutoComplete
-- hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/nvim-cmp/wiki/example-mappings#luasnip
-----------------------------------------------------------
function setup_autocomplete()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local select_next_suggestion = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      if not luasnip.jumpable then
        luasnip.expand_or_jump()
      end
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end

  local select_prev_suggestion = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end

  cmp.setup({
    window = {
      completion = cmp.config.window.bordered({
        border = "solid",
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu",
      }),
      documentation = cmp.config.window.bordered({
        border = "solid",
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu",
      }),
    },
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
      ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ["<Tab>"] = cmp.mapping(select_next_suggestion, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(select_prev_suggestion, { "i", "s" }),
      ["<Up>"] = cmp.mapping(select_prev_suggestion, { "i", "s" }),
      ["<Down>"] = cmp.mapping(select_next_suggestion, { "i", "s" }),
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

  -- "/@" suggestions
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {{ name = "nvim_lsp_document_symbol" }},
      {{ name = "buffer" }}
    )
  })

  -- cmdline & path suggestions
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {{ name = "path" }},
      {{ name = "cmdline" }}
    )
  })
end


------------------------------------------------------------
-- NeoVide
------------------------------------------------------------

if vim.g.neovide then
  vim.opt.guifont = { "JetBrains Mono", ":h10:b" }
  -- vim.opt.guifont = { "JetBrainsMono NFM", ":h10:b" }
end

-------------------------------------------------------------------------------
-- Required in path
-------------------------------------------------------------------------------
-- pacman -S gcc pyright rust-analyzer lua-language-server gopls shellcheck
-- pacman -S fd ripgrep curl tar nodejs tree-sitter ttf-nerd-fonts-symbols-mono

-- npm i -g emmet-ls
-- npm i -g typescript
-- npm i -g bash-language-server
-- npm i -g typescript-language-server
-- npm i -g vscode-langservers-extracted
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
