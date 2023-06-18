------------------------------------------------------------
-- [[ neovim ]] [[ init.lua ]] --
------------------------------------------------------------

-- title filename
vim.opt.title = true

-- hide cmd line
vim.opt.cmdheight = 0

-- show status line only in active window
-- vim.opt.laststatus = 1

-- show status line globally for active window
vim.opt.laststatus = 3

-- showcmd in statusline
vim.opt.showcmdloc = "statusline"

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

-- reduce scroll during window split
vim.opt.splitkeep = "screen"

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

------------------------------------------------------------
-- Reset "expandtab" in order to use "hard tabs"
------------------------------------------------------------

vim.cmd[[autocmd FileType ps1 setlocal noexpandtab]]
vim.cmd[[autocmd FileType rust setlocal noexpandtab]]

------------------------------------------------------------
-- list
------------------------------------------------------------
vim.opt.list = false
vim.opt.listchars = { space = "_", eol = " ", tab = "» ", trail = "~" }

------------------------------------------------------------
-- grep/vimgrep/ripgrep
------------------------------------------------------------

-- default grep program
-- vim.opt.grepprg = "grep -n $* /dev/null"

-- use ripgrep instead of grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --follow"

------------------------------------------------------------
-- Leader
------------------------------------------------------------

-- Space <Leader>
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

-- Default <Leader>
-- vim.g.mapleader = [[\]]
-- vim.g.maplocalleader = [[\]]

------------------------------------------------------------
-- edit cmd
------------------------------------------------------------

-- remove whitespace on save
vim.cmd[[au BufWritePre * :%s/\s\+$//e]]

-- don't auto comment new lines
vim.cmd[[au BufEnter * set fo-=c fo-=r fo-=o]]

-- highlight on yank
vim.api.nvim_exec2([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], { output = false })

-- disable indentline for markdown files (avoid concealing)
-- vim.cmd[[autocmd FileType markdown let g:indentLine_enabled=0]]

-- remove line lenght marker for selected filetypes
-- vim.cmd[[autocmd FileType text,markdown,xml,html,xhtml,javascript setlocal cc=0]]

-- 2 spaces for selected filetypes
-- vim.cmd[[autocmd FileType xml,html,xhtml,css,scss,javascript,json,lua,yaml setlocal shiftwidth=2 tabstop=2]]

------------------------------------------------------------
-- Rust
------------------------------------------------------------

-- rust respect user settings
vim.g.rust_recommended_style = 0

------------------------------------------------------------
-- Buffer navigation
------------------------------------------------------------

-- standard prev/next
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "gbp", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "gbn", "<cmd>bnext<cr>", { silent = true })

-- require nvim-lualine/lualine.nvim plugin
vim.keymap.set("n", "gb$", "<cmd>LualineBuffersJump $<cr>", { silent = true })
vim.keymap.set("n", "gb1", "<cmd>LualineBuffersJump! 1<cr>", { silent = true })
vim.keymap.set("n", "gb2", "<cmd>LualineBuffersJump! 2<cr>", { silent = true })
vim.keymap.set("n", "gb3", "<cmd>LualineBuffersJump! 3<cr>", { silent = true })
vim.keymap.set("n", "gb4", "<cmd>LualineBuffersJump! 4<cr>", { silent = true })
vim.keymap.set("n", "gb5", "<cmd>LualineBuffersJump! 5<cr>", { silent = true })
vim.keymap.set("n", "gb6", "<cmd>LualineBuffersJump! 6<cr>", { silent = true })
vim.keymap.set("n", "gb7", "<cmd>LualineBuffersJump! 7<cr>", { silent = true })
vim.keymap.set("n", "gb8", "<cmd>LualineBuffersJump! 8<cr>", { silent = true })
vim.keymap.set("n", "gb9", "<cmd>LualineBuffersJump! 9<cr>", { silent = true })
vim.keymap.set("n", "gb0", "<cmd>LualineBuffersJump! 10<cr>", { silent = true })

------------------------------------------------------------
-- Lazy
------------------------------------------------------------
-- ~/.cache/nvim
-- ~/.local/share/nvim/lazy
-- ~/.local/state/nvim/lazy
-- ~/.config/nvim/lazy-lock.json
------------------------------------------------------------

local Lazy = {
  plugins = {},
  path = vim.fn.stdpath("data").."/lazy/lazy.nvim",
  repository = "https://github.com/folke/lazy.nvim.git",
  config = {
    defaults = {
      lazy = true,
      version = false
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "tutor",
          "tohtml",
          "tarPlugin",
          "zipPlugin",
          "netrwPlugin"
        }
      }
    }
  }
}

-- lazy install
function Lazy.install()
  if not vim.loop.fs_stat(Lazy.path) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", Lazy.repository, "--branch=stable", Lazy.path })
  end

  -- run time path
  vim.opt.rtp:prepend(Lazy.path)
end

-- lazy add plugin
function Lazy.use(plugin)
  table.insert(Lazy.plugins, plugin)
end

-- setup all
function Lazy.setup()
  require("lazy").setup(Lazy.plugins, Lazy.config)
end

------------------------------------------------------------
-- Lazy plugins
------------------------------------------------------------

-- colorscheme
Lazy.use {
  "yavorski/dark-knight-nvim",
  -- dir = "~/dev/dark-knight-nvim",
  lazy = false,
  priority = 1024,
  config = function()
    vim.cmd[[colorscheme dark-knight]]
  end
}

-- utility lib
Lazy.use { "nvim-lua/plenary.nvim" }

-- nvim dev icons
Lazy.use { "nvim-tree/nvim-web-devicons" }

-- rust.vim
Lazy.use { "rust-lang/rust.vim", ft = "rust" }

-- stylus syntax
Lazy.use { "wavded/vim-stylus", ft = "stylus" }

-- razor syntax -> adamclerk/vim-razor
Lazy.use { "jlcrochet/vim-razor", ft = { "razor", "cshtml" } }

-- emmet html/css/js/lorem - [i] <c-m> <c-y>,
Lazy.use { "mattn/emmet-vim", ft = { "html", "cshtml", "razor", "markdown" } }

-- shows key bindings in popup
Lazy.use { "folke/which-key.nvim", event = "VeryLazy", config = true }

-- jump/repeat with f, F, t, T on multiple lines
Lazy.use { "echasnovski/mini.jump", event = "VeryLazy", config = true }

-- move any selection in any direction - [v] <Alt+hjkl>
Lazy.use { "echasnovski/mini.move", event = "VeryLazy", config = true }

-- auto pairs -> "windwp/nvim-autopairs"
Lazy.use { "echasnovski/mini.pairs", event = "VeryLazy", config = true }

-- auto comment - [n,v] <gc>
Lazy.use { "echasnovski/mini.comment", event = "VeryLazy", config = true }

-- surround - add, delete, replace, find, highlight - [n,v] <sa> <sd> <sr>
Lazy.use { "echasnovski/mini.surround", event = "VeryLazy", config = true }

-- split/join code blocks, fn args, arrays, tables - [n,v] <sj>
Lazy.use {
  "echasnovski/mini.splitjoin",
  event = "VeryLazy",
  config = function()
    local splitjoin = require("mini.splitjoin")
    local pad_brackets = splitjoin.gen_hook.pad_brackets()
    local del_separator = splitjoin.gen_hook.del_trailing_separator()

    splitjoin.setup({
      mappings = { toggle = "sj" },
      join = {
        hooks_post = {
          pad_brackets,
          del_separator
        }
      }
    })

    require("which-key").register({ sj = "Toggle Split Join" })
  end
}

-- visualize and work with indent scope animated
Lazy.use {
  "echasnovski/mini.indentscope",
  event = "VeryLazy",
  opts = {
    draw = {
      delay = 16,
      animation = function() return 0 end
    }
  }
}

-- highlight patterns / display #rrggbb colors
Lazy.use {
  "echasnovski/mini.hipatterns",
  ft = { "lua", "conf", "css", "scss", "stylus", "html", "yaml", "markdown" },
  config = function()
    local patterns = require("mini.hipatterns")
    local hex_color = patterns.gen_highlighter.hex_color()
    patterns.setup({ highlighters = { hex_color } })
  end
}

-- delete buffers without losing window layout
Lazy.use {
  "echasnovski/mini.bufremove",
  cmd = { "Bdelete", "Bwipeout" },
  keys = {{ "<leader>q", "<cmd>Bdelete<cr>", silent = true, desc = "Quit Buffer" }},
  init = function()
    -- override native bd
    vim.cmd[[cabbrev bd Bdelete]]
    vim.cmd[[cabbrev bdelete Bdelete]]

    -- override native bw
    vim.cmd[[cabbrev bw Bwipeout]]
    vim.cmd[[cabbrev bwipeout Bwipeout]]
  end,
  config = function()
    vim.api.nvim_create_user_command("Bdelete", function(opts) require("mini.bufremove").delete(0, opts.bang) end, { bang = true })
    vim.api.nvim_create_user_command("Bwipeout", function(opts) require("mini.bufremove").wipeout(0, opts.bang) end, { bang = true })
  end
}

-- minimap - window with buffer text overview
Lazy.use {
  "echasnovski/mini.map",
  keys = {{ "<leader>M", function() require("mini.map").toggle() end, silent = true, desc = "MiniMapToggle" }},
  config = function()
    local minimap = require("mini.map")

    minimap.setup({
      symbols = {
        encode = minimap.gen_encode_symbols.dot("4x2")
      },
      window = {
        width = 12,
        show_integration_count = false
      },
      integrations = {
        minimap.gen_integration.gitsigns(),
        minimap.gen_integration.diagnostic({
          info = "DiagnosticFloatingInfo",
          hint = "DiagnosticFloatingHint",
          warn = "DiagnosticFloatingWarn",
          error = "DiagnosticFloatingError"
        }),
        minimap.gen_integration.builtin_search()
      }
    })
  end
}

-- file explorer sidebar
Lazy.use {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "NvimTreeToggle",
  opts = {
    update_focused_file = {
      enable = true
    }
  },
  keys = {
    { "<leader>kb", "<cmd>NvimTreeToggle<cr>", silent = true, desc = "NvimTreeToggle" },
    { "<leader>kr", "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { "<leader>kf", "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { "<leader>K", function() require("nvim-tree.api").tree.toggle({ focus = false }) end, silent = true, desc = "NvimTreeToggle" }
  }
}

-- show marks in the sign column
Lazy.use {
  "chentoast/marks.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    refresh_interval = 420,
    default_mappings = false,
    mappings = {
      set = "m", -- "mx" set "x" mark
      delete = "dm", -- "dmx" del "x" mark
      set_next = "mn", -- set next lower case letter
      delete_line = "dm-", -- delete marks on curent line
      delete_buf = "dm<space>", -- delete marks in current buffer
      prev = "mM", -- go to prev mark
      next = "mm", -- go to next mark
    }
  }
}

-- git status signs
Lazy.use {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    trouble = false,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "]h", gs.next_hunk, { buffer = buffer, silent = true, desc = "Next Hunk" })
      vim.keymap.set("n", "gsp", gs.prev_hunk, { buffer = buffer, silent = true, desc = "Prev Hunk" })
      vim.keymap.set("n", "gsn", gs.next_hunk, { buffer = buffer, silent = true, desc = "Next Hunk" })
      vim.keymap.set("n", "gsr", gs.reset_hunk, { buffer = buffer, silent = true, desc = "Reset Hunk" })
      vim.keymap.set("n", "gsb", gs.blame_line, { buffer = buffer, silent = true, desc = "Blame Line" })
      vim.keymap.set("n", "gss", gs.stage_hunk, { buffer = buffer, silent = true, desc = "Stage Hunk" })
      vim.keymap.set("n", "gsa", gs.stage_hunk, { buffer = buffer, silent = true, desc = "Stage Hunk" })
      vim.keymap.set("n", "gsv", gs.preview_hunk, { buffer = buffer, silent = true, desc = "Preview Hunk" })
      vim.keymap.set("n", "gsu", gs.undo_stage_hunk, { buffer = buffer, silent = true, desc = "Undo Staged Hunk" })
      vim.keymap.set("n", "gsB", function() gs.blame_line({ full = true }) end, { buffer = buffer, silent = true, desc = "Blame Line Full" })
    end
  },
  init = function()
    require("which-key").register({ gs = "Git Signs" })
  end
}

-- statusline
Lazy.use {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 512,
  dependencies = {
    { "tiagovla/scope.nvim" }, -- scope buffers to tabs
    { "nvim-tree/nvim-web-devicons" }, -- use dev icons
    { "yavorski/lualine-lsp-client-name.nvim" }, -- display lsp client name
    { "yavorski/lualine-macro-recording.nvim" }, -- display macro recording
    { "whoissethdaniel/lualine-lsp-progress.nvim" }, -- display lsp progress
  },
  opts = {
    options = {
      theme = "dark-knight",
      icons_enabled = true,
      section_separators = "", -- disable separators
      component_separators = "", -- disable separators
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename", "filesize", "lsp_progress", "macro_recording", "%S" },
      lualine_x = { "selectioncount", "searchcount", "lsp_client_name", "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" }
    },
    tabline = {
      lualine_a = {{
        "buffers",
        mode = 0, -- shows only buffer name
        icons_enabled = false,
        show_filename_only = true,
        show_modified_status = true,
        hide_filename_extension = false,
        max_length = vim.o.columns, -- maximum width of buffers component
        symbols = { modified = " ^", directory = "", alternate_file = "#" },
        filetype_names = {
          fzf = "FZF",
          lazy = "Lazy",
          NvimTree = "NvimTree",
          checkhealth = "CheckHealth",
          TelescopePrompt = "Telescope",
        },
      }},
      lualine_z = { "tabs" }
    },
    extensions = { "nvim-tree" }
  },
  config = function(plugin, options)
    require("scope").setup()
    require("lualine").setup(options)
  end
}

-- fzf
Lazy.use {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    keymap = {
      builtin = {
        ["<C-u>"] = "preview-page-up",
        ["<C-d>"] = "preview-page-down"
      }
    }
  },
  config = function(_, opts)
    require("fzf-lua").setup(opts)
    -- require("fzf-lua").register_ui_select()
  end
}

-- find, filter, preview, pick
-- highly extendable fuzzy finder over lists
local is_windows = vim.loop.os_uname().sysname == "Windows" or "Windows_NT"
local fzf_windows_native = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"

Lazy.use {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = is_windows and fzf_windows_native or "make",
      config = function() require("telescope").load_extension("fzf") end
    }
  },
  opts = {
    defaults = {
      sorting_strategy = "ascending",
      file_ignore_patterns = { "^.git/", "node_modules" },
      vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "--trim" }
    },
    pickers = {
      find_files = {
        hidden = true
      }
    }
  },
  keys = {
    { "<leader>T", "<cmd>Telescope<cr>", silent = true, desc = "Telescope" },
    { "<leader>tt", "<cmd>Telescope<cr>", silent = true, desc = "Telescope" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", silent = true, desc = "Telescope Buffers" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", silent = true, desc = "Telescope Search" },
    { "<leader>f", "<cmd>Telescope find_files<cr>", silent = true, desc = "Telescope Files" },
    { "<leader>tc", "<cmd>Telescope commands<cr>", silent = true, desc = "Telescope Commands" },
    { "<leader>tj", "<cmd>Telescope jumplist<cr>", silent = true, desc = "Telescope Jump List" },
    { "<leader>tm", "<cmd>Telescope man_pages<cr>", silent = true, desc = "Telescope Man Pages" },
    { "<leader>th", "<cmd>Telescope help_tags<cr>", silent = true, desc = "Telescope Help Tags" },
    { "<leader>tg", "<cmd>Telescope git_status<cr>", silent = true, desc = "Telescope Git Status" },
  },
  init = function()
    require("which-key").register({ ["<leader>t"] = "Telescope" })
  end
}

-- select ui - lsp code actions
Lazy.use {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = { enabled = false },
    select = {
      enabled = true,
      trim_prompt = false,
      backend = { "fzf_lua", "builtin" },
      fzf_lua = { winopts = { width = 0.4, height = 0.25 } },
      builtin = {
        border = "solid",
        min_width = { 80, 0.2 },
        min_height = { 4, 0.1 },
        win_options = { winhighlight = "FloatTitle:FloatBorder" }
      }
    }
  }
}

-- diagnostics, references, telescope results, quickfix and location list
Lazy.use {
  "folke/trouble.nvim",
  cmd = { "Trouble", "TroubleToggle" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    icons = false,
    padding = false,
    indent_lines = false,
    -- auto_preview = true,
    -- action_keys = { toggle_preview = "<space>" },
    auto_jump = {
      "lsp_references",
      "lsp_definitions",
      "lsp_implementations",
      "lsp_type_definitions"
    },
    signs = { hint = "★", error = "✖", warning = "◀", other = "⬕", information = "▣" },
  },
  init = function()
    -- prevent initial auto_preview on open
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "Trouble",
      callback = function()
        local time = 0;
        local timer = vim.loop.new_timer()

        if timer ~= nil then
          timer:start(0, 16, function()
            if time == 256 then
              timer:stop()
              timer:close()
            end
            time = time + 16
            vim.schedule(function() vim.api.nvim_feedkeys("gg", "n", true) end)
          end)
        end
      end
    })
  end
}

-- ui for messages, cmdline, search and popupmenu
Lazy.use {
  "folke/noice.nvim",
  -- dir = "~/dev/open-sos/noice.nvim",
  event = "VeryLazy",
  dependencies = {{ "muniftanjim/nui.nvim" }},
  opts = {
    notify = { view = "mini" },
    messages = { enabled = true },
    popupmenu = { kind_icons = false },
    cmdline_output = { enabled = true},
    presets = {
      long_message_to_split = true,
      cmdline_output_to_split = true,
    },
    cmdline = {
      view = "cmdline_popup",
      format = {
        lua = { icon = "" },
        help = { icon = "" },
        filter = { icon = "$" },
        cmdline = { icon = "" },
        search_up = { icon = "🔍⇡" },
        search_down = { icon = "🔍⇣" }
      }
    },
    lsp = {
      hover = { enabled = false },
      message = { enabled = true },
      progress = { enabled = false },
      signature = { enabled = false },
      documentation = { enabled = false }
    },
    commands = {
      history = { view = "popup" }
    },
    routes = {
      { view = "notify", filter = { event = "msg_showmode" } }
    },
    format = {
      level = { icons = { error = "✖ ", warn = "◀ ", info = "▣ " } }
    },
    views = {
      notify = { merge = true, replace = true },
      messages = { view = "popup", enter = true },
      confirm = {
        border = { style = "none", padding = { 1, 2 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      },
      popup = {
        border = { style = "none", padding = { 1, 2 } }
      },
      popupmenu = {
        size = { max_height = 32 },
        border = { style = "single", padding = { 0, 1 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } },
      },
      cmdline_popup = {
        align = "center",
        position = { row = 8, col = "50%" },
        size = { width = 80, height = "auto" },
        border = { style = "none", padding = { 1, 2 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      },
      cmdline_popupmenu = {
        position = { row = 12, col = "50%" },
        size = { width = 80, height = "auto" },
        border = { style = "none", padding = { 1, 2 } },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      },
      mini = {
        timeout = 2800,
        focusable = false,
        border = { style = "none", padding = { 1, 2 } },
        position = { row = 3, col = "98%" },
        win_options = { winhighlight = { Normal = "NormalFloat" } }
      }
    }
  },
  init = function()
    vim.keymap.set("n", "<esc>", "<cmd>Noice dismiss<cr>")
  end
}

-- tree-sitter is a parser generator tool and an incremental parsing library
-- tree-sitter can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited
Lazy.use {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    { "windwp/nvim-ts-autotag" }, -- auto close/rename html tag
    { "nvim-treesitter/playground", enabled = false }, -- view treesitter information
  },
  opts = {
    ensure_installed = "all",
    indent = { enable = true }, -- indentation for = operator
    autotag = { enable = true }, -- auto close/rename html tag
    highlight = { enable = true }, -- false will disable the extension
    playground = { enable = false }, -- Inspect/TSHighlightCapturesUnderCursor
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>"
      }
    }
  },
  config = function(plugin, options)
    require("nvim-treesitter.configs").setup(options)
  end
}

-- arround/inside text objects
-- text-objects move to class/function/method
Lazy.use {
  "echasnovski/mini.ai",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-textobjects" }
  },
  keys = {
    { "a", mode = { "x", "o" } },
    { "i", mode = { "x", "o" } },
    { "[[", desc = "Prev start @class" },
    { "]]", desc = "Next start @class" },
    { "[]", desc = "Prev end @class" },
    { "][", desc = "Next end @class" },
    { "[f", desc = "Prev start @function" },
    { "]f", desc = "Next start @function" },
    { "[F", desc = "Prev end @function" },
    { "]F", desc = "Next end @function" },
  },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 420,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
      },
    }
  end,
  config = function(plugin, options)
    require("mini.ai").setup(options)
    require("nvim-treesitter.configs").setup({
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start     = { ["]]"] = "@class.outer", ["]f"] = "@function.outer" },
          goto_next_end       = { ["]["] = "@class.outer", ["]F"] = "@function.outer" },
          goto_previous_start = { ["[["] = "@class.outer", ["[f"] = "@function.outer" },
          goto_previous_end   = { ["[]"] = "@class.outer", ["[F"] = "@function.outer" },
        }
      }
    })
  end
}

------------------------------------------------------------
-- LSP - setup
-- neovim/nvim-lspconfig
------------------------------------------------------------
local LSP = {
  opts = {
    border = "solid",

    diagnostics = {
      signs = true,
      underline = false,
      virtual_text = true,
      severity_sort = true,
      update_in_insert = false,
      float = { border = "solid" },
      icons = { Info = "▣", Hint = "★", Warn = "◀", Error = "✖" }
    },

    servers = {
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
  }
}

------------------------------------------------------------
-- LSP init settings and servers
------------------------------------------------------------
LSP.init = function()
  LSP.UI()
  LSP.keymaps()
  LSP.setup_lua()
  LSP.setup_rust()
  -- LSP.setup_dotnet()
  LSP.setup_powershell()
  LSP.setup_listed_servers()
end

------------------------------------------------------------
-- LSP user interface settings
------------------------------------------------------------
LSP.UI = function()
  vim.diagnostic.config(LSP.opts.diagnostics)

  for type, icon in pairs(LSP.opts.diagnostics.icons) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  require("lspconfig.ui.windows").default_options.border = LSP.opts.border

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = LSP.opts.border })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = LSP.opts.border })
end

------------------------------------------------------------
-- LSP buffer keymaps
------------------------------------------------------------
LSP.buffer_keymaps = function(buffer)
  -- enable completion triggered by <c-x><c-o>
  vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- key map fn
  local function keymap(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = buffer, desc = desc })
  end

  -- keymap("n", "gr", vim.lsp.buf.references, "LSP References")
  keymap("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", "LSP References")

  -- keymap("n", "gd", vim.lsp.buf.definition, "LSP Definition")
  keymap("n", "gd", "<cmd>TroubleToggle lsp_definitions<cr>", "LSP Definition")

  -- no trouble declaration
  keymap("n", "gD", vim.lsp.buf.declaration, "LSP Declaration")

  -- keymap("n", "gi", vim.lsp.buf.implementation, "LSP Implementation")
  keymap("n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>", "LSP Implementation")

  -- keymap("n", "g<space>", vim.lsp.buf.type_definition, "LSP Type Definition")
  keymap("n", "g<space>", "<cmd>TroubleToggle lsp_type_definitions<cr>", "LSP Type Definition")

  keymap("n", "K", vim.lsp.buf.hover, "LSP Hover")
  keymap("n", "<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")

  keymap("n", "<leader>R", vim.lsp.buf.rename, "LSP Rename")
  keymap("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format")
  keymap("v", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "LSP Format Visual")

  keymap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
  keymap("v", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")

  keymap("n", "[d", vim.diagnostic.goto_prev, "LSP Diagnostic Prev")
  keymap("n", "]d", vim.diagnostic.goto_next, "LSP Diagnostic Next")
  keymap("n", "<leader>er", vim.diagnostic.open_float, "LSP Diagnostic Open Float")

  keymap("n", "<leader>tq", "<cmd>Telescope diagnostics layout_strategy=vertical<cr>", "Telescope LSP Diagnostics")
  keymap("n", "<leader>tr", "<cmd>Telescope lsp_references layout_strategy=vertical<cr>", "Telescope LSP References")
  keymap("n", "<leader>td", "<cmd>Telescope lsp_definitions layout_strategy=vertical<cr>", "Telescope LSP Definitions")
  keymap("n", "<leader>ti", "<cmd>Telescope lsp_implementations layout_strategy=vertical<cr>", "Telescope LSP Implementations")
  keymap("n", "<leader>ts", "<cmd>Telescope lsp_document_symbols layout_strategy=vertical<cr>", "Telescope LSP Document Symbols")

  keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "LSP Add Workspace Folder")
  keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "LSP Remove Workspace Folder")
  keymap("n", "<leader>wq", "<cmd>TroubleToggle workspace_diagnostics<cr>", "LSP Workspace Diagnostics")
  keymap("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "LSP Workspace List Folders")

  require("which-key").register({ ["<leader>w"] = "LSP Workspace" })
end

------------------------------------------------------------
-- LSP - attach keymaps on LspAttach event
------------------------------------------------------------
LSP.keymaps = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      LSP.buffer_keymaps(event.buf)
    end
  })
end

------------------------------------------------------------
-- LSP - client capabilities
------------------------------------------------------------
LSP.capabilities = function()
  local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = vim.tbl_deep_extend("force", {}, client_capabilities, lsp_capabilities)
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

------------------------------------------------------------
-- LSP - setup listed servers from options
------------------------------------------------------------
LSP.setup_listed_servers = function()
  local lsp = require("lspconfig")
  local servers = LSP.opts.servers

  for _, server in ipairs(servers) do
    lsp[server].setup({
      capabilities = LSP.capabilities()
    })
  end
end

------------------------------------------------------------
-- LSP Rust rust_analyzer -- simrat39/rust-tools.nvim
------------------------------------------------------------
LSP.setup_rust = function()
  require("rust-tools").setup({
    server = {
      capabilities = LSP.capabilities(),
    }
  })
end

------------------------------------------------------------
-- LSP Lua for neovim lua api
-- folke/neodev.nvim - should be first in setup order
------------------------------------------------------------
LSP.setup_neodev = function()
  require("neodev").setup({
    library = {
      types = true,
      enabled = true,
      runtime = true,
      plugins = true,
    },
    lspconfig = true,
    pathStrict = true,
    setup_jsonls = true,
    override = function(root_dir, library)
      library.enabled = true
      library.plugins = true
    end
  })
end

------------------------------------------------------------
-- LSP Lua lus_ls -- sumneko/lua-language-server
------------------------------------------------------------
LSP.setup_lua = function()
  LSP.setup_neodev()

  require("lspconfig").lua_ls.setup({
    capabilities = LSP.capabilities(),
    settings = {
      Lua = {
        format = { enable = true },
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim", "teardown" } },
        -- runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
        -- workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false }
        -- workspace = { library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true } }
      }
    }
  })
end

------------------------------------------------------------
-- LSP dotnet - omnisharp
-- pacman -S dotnet-runtime dotnet-sdk aspnet-runtime
-- pacman AUR -S omnisharp-roslyn
-- https://github.com/omnisharp/omnisharp-roslyn
-- https://github.com/hoffs/omnisharp-extended-lsp.nvim
------------------------------------------------------------
LSP.setup_dotnet = function()
  local pid = vim.fn.getpid()
  local omnisharp_bin = "/usr/bin/omnisharp"

  -- @todo fix - requires telescope, so lazy is broken
  local omnisharp_extended = require("omnisharp_extended")

  require("lspconfig").omnisharp.setup({
    capabilities = LSP.capabilities(),
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },

    -- omnisharp extended handler
    handlers = { ["textDocument/definition"] = omnisharp_extended.handler },

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
end

------------------------------------------------------------
-- LSP powershell
-- https://github.com/powershell/powershelleditorservices
-- pacman AUR -S powershell-bin powershell-editor-services
------------------------------------------------------------
LSP.setup_powershell = function()
  local win_path = "C:/dev/ps-es-lsp"
  local linux_path = "/opt/powershell-editor-services"

  require("lspconfig").powershell_es.setup({
    capabilities = LSP.capabilities(),
    bundle_path = is_windows and win_path or linux_path
  })
end

------------------------------------------------------------
-- Lazy LSP setup
------------------------------------------------------------
Lazy.use {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "folke/neodev.nvim" }, -- init.lua, plugin development, signature help, docs and completion for the nvim lua api
    { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin LSP client
    { "simrat39/rust-tools.nvim" }, -- extra functionality over rust analyzer
    { "hoffs/omnisharp-extended-lsp.nvim", enabled = false }, -- extend "textDocument/definition" handler for OmniSharp Neovim LSP
  },
  config = function()
    LSP.init()
  end
}

------------------------------------------------------------
-- AutoComplete
-- hrsh7th/nvim-cmp
------------------------------------------------------------

local AutoComplete = {
  cmp = nil,
  snip = nil,

  opts = {
    border = "solid",
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
  }
}

AutoComplete.init = function()
  AutoComplete.cmp = require("cmp")
  AutoComplete.snip = require("luasnip")
end

AutoComplete.has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

AutoComplete.select_next_suggestion = function(fallback)
  local cmp = AutoComplete.cmp
  local snip = AutoComplete.snip

  if cmp == nil or snip == nil then
    error("AutoComplete: Missing CMP or LuaSnip.")
  end

  if cmp.visible() then
    cmp.select_next_item()
  elseif snip.expand_or_locally_jumpable() then
    snip.expand_or_jump()
  elseif AutoComplete.has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

AutoComplete.select_prev_suggestion = function(fallback)
  local cmp = AutoComplete.cmp
  local snip = AutoComplete.snip

  if cmp == nil or snip == nil then
    error("AutoComplete: Missing CMP or LuaSnip.")
  end

  if cmp.visible() then
    cmp.select_prev_item()
  elseif snip.jumpable(-1) then
    snip.jump(-1)
  else
    fallback()
  end
end

AutoComplete.setup = function()
  local cmp = AutoComplete.cmp
  local snip = AutoComplete.snip
  local border = AutoComplete.opts.border
  local winhighlight = AutoComplete.opts.winhighlight

  if cmp == nil or snip == nil then
    error("AutoComplete: Missing CMP or LuaSnip.")
  end

  cmp.setup({
    window = {
      completion = cmp.config.window.bordered({ border = border, winhighlight = winhighlight }),
      documentation = cmp.config.window.bordered({ border = border, winhighlight = winhighlight }),
    },
    completion = { completeopt = "menu,menuone,noselect" },
    experimental = { ghost_text = { hl_group = "LspCodeLens" } },
    snippet = {
      expand = function(args)
        snip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-a>"] = cmp.mapping.abort(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-c>"] = cmp.mapping.close(),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
      ["<S-CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      ["<Tab>"] = cmp.mapping(AutoComplete.select_next_suggestion, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(AutoComplete.select_prev_suggestion, { "i", "s" }),
      ["<Up>"] = cmp.mapping(AutoComplete.select_prev_suggestion, { "i", "s" }),
      ["<Down>"] = cmp.mapping(AutoComplete.select_next_suggestion, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp_signature_help", priority = 64, group_index = 1 },
      { name = "nvim_lsp", priority = 32, group_index = 2 },
      { name = "nvim_lua", priority = 16, group_index = 3 },
      { name = "luasnip", priority = 8, group_index = 4 },
      { name = "buffer", priority = 4, group_index = 5 },
      { name = "path", priority = 2, group_index = 6 },
    })
  })

  -- "/@" suggestions
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
      {{ name = "buffer" }},
      {{ name = "nvim_lsp_document_symbol" }}
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
-- Lazy AutoComplete setup
------------------------------------------------------------
Lazy.use {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-path" }, -- nvim-cmp source for path
    { "hrsh7th/cmp-buffer" }, -- nvim-cmp source for buffer words
    { "hrsh7th/cmp-cmdline" }, -- nvim-cmp source for vim's cmdline
    { "hrsh7th/cmp-nvim-lua" }, -- nvim-cmp source for neovim Lua API
    { "hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for neovim builtin lsp client
    { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- nvim-cmp source for displaying function signatures with the current parameter emphasized
    { "hrsh7th/cmp-nvim-lsp-document-symbol" }, -- nvim-cmp source for textDocument/documentSymbol via nvim-lsp.
    { "saadparwaiz1/cmp_luasnip" }, -- luasnip completion source for nvim-cmp
    { "l3mon4d3/luasnip" }, -- snippet engine
  },
  config = function()
    AutoComplete.init()
    AutoComplete.setup()
  end
}

------------------------------------------------------------
-- Lazy init
------------------------------------------------------------

-- install lazy plugin manager
Lazy.install()

-- install all configured plugins
Lazy.setup()

------------------------------------------------------------
-- NeoVide
------------------------------------------------------------

if vim.g.neovide then
  vim.opt.guifont = { "IntelOne Mono", ":h11.25:b" }
  -- vim.opt.guifont = { "JetBrains Mono", ":h10:b" }
  -- vim.opt.guifont = { "JetBrainsMono NFM", ":h10:b" }
end

--------------------------------------------------------------------------------
-- Troubleshoot
--------------------------------------------------------------------------------
-- :Rust
-- :LspInfo
-- :checkhealth
-- :set filetype?
-- :set cmdheight=2
-- :set completeopt?
-- :verbose imap <tab>
-- :verbose set completeopt?
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Required in path
--------------------------------------------------------------------------------
-- npm i -g emmet-ls
-- npm i -g typescript
-- npm i -g bash-language-server
-- npm i -g typescript-language-server
-- npm i -g vscode-langservers-extracted
-- npm i -g dockerfile-language-server-nodejs

-- pacman -S zig gcc rust-analyzer lua-language-server pyright shellcheck
-- pacman -S fd ripgrep tar curl nodejs tree-sitter ttf-nerd-fonts-symbols-mono
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- LSP server configurations
------------------------------------------------------------------------------------
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
------------------------------------------------------------------------------------
