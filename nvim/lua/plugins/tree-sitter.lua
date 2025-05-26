-- TODO -- switch to main branch

local Lazy = require("core/lazy")

-- tree-sitter
-- nvim --headless +"Lazy load nvim-treesitter" +TSUpdateSync +qa!
-- nvim --headless +"Lazy load nvim-treesitter" +"TSInstallSync! all" +qa!
-- nvim --headless +"Lazy load nvim-treesitter" +"TSInstallFromGrammar! all" +qa!
Lazy.use {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = "all",
    ignore_install = { "bp", "just", "norg", "foam", "hoon", "rnoweb", "gdshader" },
    indent = {
      enable = true, -- indentation for = operator
      disable = { "html", "yaml" } -- disable for these filetypes
    },
    playground = { enable = false }, -- Inspect/TSHighlightCapturesUnderCursor
    highlight = {
      enable = true, -- false will disable the extension
      disable = function(_, buf)
        local max_filesize = 100 * 1024 -- 100kb
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false -- setting this to true will run syntax and tree-sitter at the same time
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        node_decremental = "<bs>",
        scope_incremental = false,
      }
    }
  },
  config = function(_, options)
    -- require("nvim-treesitter.install").compilers = { "cc", "gcc", "clang", "cl", "zig" }
    require("nvim-treesitter.install").prefer_git = false
    require("nvim-treesitter.configs").setup(options)
  end
}
