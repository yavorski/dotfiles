-----------------------------------------------------------
-- Packer
-----------------------------------------------------------
local packer_git_url = 'https://github.com/wbthomason/packer.nvim'
local packer_install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', packer_git_url, packer_install_path })
  vim.cmd[[packadd packer.nvim]]
end
------------------------------------------------------------
-- [[ init.lua ]] --
------------------------------------------------------------

-- title filename
vim.opt.title = true

-- syntax highlighting
vim.opt.syntax = 'enable'

-- dark/light
vim.opt.background = 'dark'

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

-- enable folding (default 'foldmarker')
vim.opt.foldmethod = 'marker'

-- intro / hit-enter prompts / ins-completion-menu
vim.opt.shortmess = 'actI'

-- line lenght marker
-- vim.opt.colorcolumn = '115'

-- signcolumn
vim.opt.signcolumn = 'auto'

-- enable mouse
vim.opt.mouse = 'a'

-- min number of screen lines above/below the cursor
vim.opt.scrolloff = 4

-- vertical split to the right
vim.opt.splitright = true

-- system clipboard
vim.opt.clipboard = 'unnamedplus'

-- ignore case in search patterns
vim.opt.ignorecase = true

-- override the 'ignorecase' option if the search containse upper characters
vim.opt.smartcase = true

-- complete menu
vim.opt.completeopt = 'menu,menuone,noselect'

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

-- rust respect user settings
vim.g.rust_recommended_style = 0

-- list
vim.opt.list = false
vim.opt.listchars = { space = '_', eol = '↲', tab = '▸~', trail = '·' }

-- default grep program
-- vim.opt.grepprg = 'grep -n $* /dev/null'

-- use ripgrep instead of grep
vim.opt.grepprg = 'rg --vimgrep --smart-case --hidden --follow'

-----------------------------------------------------------

-----------------------------------------------------------

-- <Leader>
-- vim.g.mapleader = [[\]]      -- Default is '\'
-- vim.g.maplocalleader = [[\]] -- Default is '\'

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
-- Packer
-----------------------------------------------------------
local packer = require('packer')
local packer_git_url = 'https://github.com/wbthomason/packer.nvim'
local packer_install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

-- install packer
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', packer_git_url, packer_install_path })
  vim.cmd[[packadd packer.nvim]]
end

-- setup packer
packer.startup(function()
  local use = packer.use

  -- packer
  use { 'wbthomason/packer.nvim' }

  -- colorscheme
  use {
    'glepnir/zephyr-nvim',
    config = function()
      require('zephyr')
    end
  }

  -- statusline
  use {
    'hoob3rt/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'onedark',
          icons_enabled = true,
          section_separators = '', -- disable separators
          component_separators = '', -- disable separators
        }
      })
    end
  }

  -- file explorer tree written in lua
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup()
      vim.api.nvim_set_keymap('n', '<leader>kb', '<cmd>lua require("nvim-tree").toggle()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>kr', '<cmd>lua require("nvim-tree").refresh()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>kf', '<cmd>lua require("nvim-tree").find_file()<cr>', { noremap = true, silent = true })
    end
  }

  -- git status signs
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- shows keybindings in popup
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup()
    end
  }

  -- show marks in the sign column
  use {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({})
    end
  }

  -- find, filter, preview, pick
  -- highly extendable fuzzy finder over lists -> :Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          sorting_strategy = "ascending",
          file_ignore_patterns = { '.git', 'node_modules' },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden'
          }
        },
        pickers = {
          find_files = {
            hidden = true
          }
        }
      })

      -- load telescope-fzf-native.nvim
      require('telescope').load_extension('fzf')

      vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>rg', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>th', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { noremap = true, silent = true })
    end
  }

  -- tree-sitter is a parser generator tool and an incremental parsing library
  -- tree-sitter can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      -- additional text objects for treesitter
      -- { 'nvim-treesitter/nvim-treesitter-textobjects' }
    },
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        ignore_install = { 'lua' },
        highlight = {
          enable = true -- false will disable the extension
        },
        indent = {
          enable = true -- indentation based on treesitter for the = operator
        }
      })
    end
  }

  -- autopairs for neovim written by lua
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  -- use treesitter to auto close and auto rename html tag
  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }

  -- Stylus support
  -- use { 'iloginow/vim-stylus' }

  -- Multiple cursors
  -- use { 'mg979/vim-visual-multi' }

  -- LSP
  -- collection of common configurations for neovim's built-in language server client
  use { 'neovim/nvim-lspconfig' }

  -- AutoComplete
  use { 'hrsh7th/nvim-cmp' } -- completion plugin for neovim coded in lua

  -- AutoComplete Sources
  use { 'hrsh7th/cmp-path' } -- nvim-cmp source for path
  use { 'hrsh7th/cmp-buffer' } -- nvim-cmp source for buffer words
  use { 'hrsh7th/cmp-cmdline' } -- nvim-cmp source for vim's cmdline
  use { 'hrsh7th/cmp-nvim-lsp' } -- !nvim-cmp source for neovim builtin lsp client

  use { 'L3MON4D3/LuaSnip' } -- snippet engine for neovim written in lua
  use { 'saadparwaiz1/cmp_luasnip' } -- luasnip completion source for nvim-cmp
  use { 'sumneko/lua-language-server' } -- lua language server coded by lua

  -- Rust tools lsp/cmp
  use { 'rust-lang/rust.vim' } -- vim configuration for rust.
  use { 'simrat39/rust-tools.nvim' } -- tools for better development in rust using neovim's builtin lsp. adds extra functionality over rust analyzer
  -- use { 'Saecki/crates.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- helps managing crates.io dependencies

  -- emmet html/css/js/lorem
  use {
    'mattn/emmet-vim',
    config = function()
      vim.api.nvim_set_var('user_emmet_mode', 'a') --//-- enable all functions in all modes
    end
  }
end)

-----------------------------------------------------------
-- LSP
-----------------------------------------------------------
-- Required in path

-- pacman -S gcc pyright rust-analyzer lua-language-server gopls
-- pacman -S fd ripgrep curl tar nodejs ttf-nerd-fonts-symbols-mono

-- npm i -g typescript
-- npm i -g typescript-language-server
-- npm i -g bash-language-server
-- npm i -g dockerfile-language-server-nodejs
-- npm i -g vscode-langservers-extracted

-- --> vscode-css-languageservice
-- --> vscode-html-languageservice
-- --> vscode-json-languageservice

-- Documentation
-- neovim/nvim-lspconfig
-- https://langserver.org/
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
-- https://microsoft.github.io/language-server-protocol/implementors/servers/
-----------------------------------------------------------
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  -- enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'g<space>', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>qq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>er', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)

  -- list lsp document symbols in telescope
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lds', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], opts)

  -- vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- enable the following language servers
-- call 'setup' on multiple servers and map buffer local keybindings when the language server attaches
local servers = {
  'html',
  'cssls',
  'gopls',
  'jsonls',
  'bashls',
  'clangd',
  'pyright',
  'tsserver',
  'dockerls',
  -- 'rust_analyzer',
  -- 'lua-language-server',
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
require('rust-tools').setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
})

-----------------------------------------------------------
-- lua lsp server
-- sumneko/lua-language-server
-----------------------------------------------------------
local sumneko_bin = vim.fn.exepath('lua-language-server')
local sumneko_root = vim.fn.stdpath('data')..'/site/pack/packer/start/lua-language-server'

nvim_lsp.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { sumneko_bin, '-E', sumneko_root .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        -- LuaJIT in case of Neovim
        version = 'LuaJIT',
        -- Setup lua path
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim'
        }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      },
      -- telemetry
      telemetry = {
        enable = false
      }
    }
  }
})

-----------------------------------------------------------
-- AutoComplete
-- hrsh7th/nvim-cmp
-----------------------------------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'path' },
    { name = 'buffer' },
    { name = 'cmdline' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
  }
})


-----------------------------------------------------------
-- Troubleshoot
-----------------------------------------------------------
-- :Rust
-- :LspInfo
-- :Telescope
-----------------------------------------------------------
-- :checkhealth
-- :set cmdheight=2
-- :set completeopt?
-- :verbose imap <tab>
-- :verbose set completeopt?
-----------------------------------------------------------
