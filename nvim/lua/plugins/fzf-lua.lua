--- @brief
--- @module "fzf-lua"
--- fzf-lua picker & vim ui select handler

local Lazy = require("core/lazy")
local system = require("core/system")
local window_border = require("core/border")

-- state - before opening fzf-lua
local cpwin, cpbuf, tree_focus = nil, nil, nil

-- wrapper
-- if nvim-tree is open go to prev window before opening fzf-lua
-- this will prevent opening the selected fzf-lua file in the nvim-tree window
-- fzf-lua will default to opening splits if winfixbuf is set on nvim-tree or any window from which it was started
--- @param cmd string The fzf-lua command to execute (e.g., "FzfLua files", "FzfLua buffers")
local function start(cmd)
  cpwin, cpbuf, tree_focus = nil, nil, nil

  if vim.g.NvimTreeRequired == 1 then
    if require("nvim-tree.api").tree.is_visible() then
      if require("nvim-tree.api").tree.winid() == vim.api.nvim_get_current_win() then
        vim.cmd("wincmd p") -- >> cmd = "wincmd p | " .. cmd
        tree_focus, cpwin, cpbuf = true, vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
      end
    end
  end

  vim.cmd(cmd)
end

-- on fzf-lua close handler
-- remove split for winfixbuf
-- if nvim-tree was opened and focused when fzf-lua started
-- restore focus to nvim-tree if no file was selected from fzf-lua, or fzf-lua was canceled
local function on_close()
  vim.schedule(function()
    if tree_focus and require("nvim-tree.api").tree.is_visible() and cpwin == vim.api.nvim_get_current_win() and cpbuf == vim.api.nvim_get_current_buf() then
      require("nvim-tree.api").tree.focus()
    end
    -- reset state
    cpwin, cpbuf, tree_focus = nil, nil, nil
  end)
end

-- fzf utility
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
    zindex = 128, -- neovide fix multiple floating windows
    backdrop = 100,
    on_close = on_close,
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
  grep = {
    winopts = vertical(),
    RIPGREP_CONFIG_PATH = vim.fn.expand(vim.env.RIPGREP_CONFIG_PATH)
  },
  diagnostics = { winopts = vertical(), multiline = false },
}

-- fzf
Lazy.use {
  "ibhagwan/fzf-lua",
  -- dir = "~/dev/open-sos/fzf-lua",
  dependencies = { "nvim-mini/mini.icons" },
  cmd = "FzfLua",
  event = system.is_windows and "VeryLazy" or nil,
  opts = fzf_lua_options,
  keys = {
    { "<leader>tt", function() start("FzfLua") end, silent = true, desc = "FZF Lua" },
    { "<leader>'", function() start("FzfLua resume") end, silent = true, desc = "FZF Resume" },
    { "<leader>b", function() start("FzfLua buffers") end, silent = true, desc = "FZF Buffers" },
    { "<leader>j", function() start("FzfLua jumps") end, silent = true, desc = "FZF Jumps List" },
    { "<leader>h", function() start("FzfLua helptags") end, silent = true, desc = "FZF Help Tags" },
    { "<leader>M", function() start("FzfLua manpages") end, silent = true, desc = "FZF Man Pages" },
    { "<leader>g", function() start("FzfLua git_status") end, silent = true, desc = "FZF Git Status" },
    { "<leader>f", function() start("FzfLua files") end, silent = true, desc = "FZF Files" },
    { "<leader>/", function() start("FzfLua grep_visual") end, mode = "v", silent = true, desc = "FZF Search" },
    { "<leader>/", function() start("FzfLua live_grep_native") end, mode = "n", silent = true, desc = "FZF Search" },
  },
  config = function()
    require("fzf-lua").setup(fzf_lua_options)
    require("fzf-lua").register_ui_select(setup_ui_select)
  end
}
