local Lazy = require("core/lazy")
local System = require("core/system")
local window_border = require("core/border")

-- fzf
local function vertical(border)
  return {
    preview = {
      layout = "vertical",
      vertical = "down:75%",
      border = border ~= nil and border or window_border -- or "solid"
    }
  }
end

-- register ui select handler
local function setup_ui_select(opts)
  if opts.kind == "codeaction" then
    return { winopts = vertical() }
  end

  return {
    winopts = {
      row = 0.25,
      width = 0.7,
      height = 0.42
    }
  }
end

--- @module "fzf-lua"
--- @type fzf-lua.Config
local fzf_lua_options = {
  defaults = {
    file_icons = "mini",
    multiprocess = true,
    preview_pager = false,
    file_ignore_patterns = { "package%-lock%.json" }
  },
  fzf_colors = true,
  fzf_opts = {
    ["--cycle"] = "",
    -- ["--scrollbar"] = "█"
  },
  winopts = {
    row = 0.45,
    col = 0.50,
    width = 0.80,
    height = 0.87,
    border = window_border, -- or "solid"
    backdrop = 100,
    preview = {
      default = "builtin",
      border = window_border, -- or "solid"
      vertical = "down:50%",
      horizontal = "right:51%",
      scrollbar = "border", -- or "float"
      winopts = { number = false }
    }
  },
  keymap = {
    builtin = {
      ["<A-k>"] = "preview-up",
      ["<A-j>"] = "preview-down",
      ["<A-up>"] = "preview-up",
      ["<A-down>"] = "preview-down",
      ["<C-up>"] = "preview-up",
      ["<C-down>"] = "preview-down",
      ["<C-u>"] = "preview-page-up",
      ["<C-d>"] = "preview-page-down",
    },
    fzf = {
      ["ctrl-u"] = "preview-page-up",
      ["ctrl-d"] = "preview-page-down"
    }
  },
  lsp = {
    winopts = vertical(),
    code_actions = { winopts = vertical() },
  },
  git = {
    tags = { winopts = vertical("border-top") },
    blame = { winopts = vertical("border-top") },
    stash = { winopts = vertical("border-top") },
    status = { winopts = vertical("border-top") },
    commits = { winopts = vertical("border-top") },
    branches = { winopts = vertical("border-top") },
  },
  grep = { winopts = vertical() },
  diagnostics = { winopts = vertical(), multiline = false },
}

-- fzf
Lazy.use {
  "ibhagwan/fzf-lua",
  -- dir = "~/dev/open-sos/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  cmd = "FzfLua",
  event = System.is_windows and "VeryLazy" or nil,
  opts = fzf_lua_options,
  keys = {
    { "<leader>tt", "<cmd>FzfLua<cr>", silent = true, desc = "FZF Lua" },
    { "<leader>'", "<cmd>FzfLua resume<cr>", silent = true, desc = "FZF Resume" },
    { "<leader>b", "<cmd>FzfLua buffers<cr>", silent = true, desc = "FZF Buffers" },
    { "<leader>j", "<cmd>FzfLua jumps<cr>", silent = true, desc = "FZF Jumps List" },
    { "<leader>h", "<cmd>FzfLua helptags<cr>", silent = true, desc = "FZF Help Tags" },
    { "<leader>m", "<cmd>FzfLua manpages<cr>", silent = true, desc = "FZF Man Pages" },
    { "<leader>g", "<cmd>FzfLua git_status<cr>", silent = true, desc = "FZF Git Status" },
    { "<leader>f", "<cmd>FzfLua files header=false<cr>", silent = true, desc = "FZF Files" },
    { "<leader>/", "<cmd>FzfLua grep_visual<cr>", mode = "v", silent = true, desc = "FZF Search" },
    { "<leader>/", "<cmd>FzfLua live_grep_native<cr>", mode = "n", silent = true, desc = "FZF Search" },
  },
  config = function(_, options)
    require("fzf-lua").setup(options)
    require("fzf-lua").register_ui_select(setup_ui_select)
  end
}
