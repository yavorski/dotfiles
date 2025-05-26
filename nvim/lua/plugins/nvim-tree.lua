--- @brief
--- @module "nvim-tree"
--- File explorer tree - sidebar or floating window

local Lazy = require("core/lazy")
local window_border = require("core/border")

local FLOAT = true
local OFFSET = 4
local MIN_WIDTH = FLOAT and 42 or 30

local options = {
  git = { timeout = 2048 },
  sync_root_with_cwd = true,
  view = {
    side = FLOAT and "right" or "left",
    width = {
      min = MIN_WIDTH,
      padding = 2
    },
    adaptive_size = true,
    float = {
      enable = FLOAT,
      quit_on_focus_loss = true,
      open_win_config = {
        col = vim.o.columns - MIN_WIDTH - OFFSET, -- align to right
        height = vim.o.lines - OFFSET, -- use full height
        border = window_border
      }
    }
  },
  update_focused_file = {
    enable = true
  },
  actions = {
    file_popup = {
      open_win_config = {
        border = window_border
      }
    }
  },
  filters = {
    custom = { "^\\.git$" }
  }
}

local function align_float_right()
  local api = require("nvim-tree.api")

  if not api.tree.is_visible() then
    return
  end

  local winid = api.tree.winid()
  local config = vim.api.nvim_win_get_config(winid)
  local desired_column = vim.o.columns - config.width - OFFSET

  if desired_column ~= config.col then
    config.col = desired_column
    vim.api.nvim_win_set_config(winid, config)
  end
end

Lazy.use {
  "nvim-tree/nvim-tree.lua",
  cmd = {
    "NvimTreeOpen",
    "NvimTreeToggle"
  },
  keys = {
    { [[<leader>\r]], "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { [[<leader>\f]], "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { [[<leader>\F]], "<cmd>NvimTreeFindFile!<cr>", silent = true, desc = "NvimTreeFindFile!" },
    -- { [[<leader>\\]], "<cmd>NvimTreeToggle<cr>", silent = true, desc = "NvimTreeToggle" },
    { [[<leader>\\]], function() require("nvim-tree.api").tree.toggle({ focus = FLOAT }) end, silent = true, desc = "NvimTreeToggle" },
  },
  config = function()
    require("nvim-tree").setup(options)

    if FLOAT then
      local api = require("nvim-tree.api")
      local Event = api.events.Event

      api.events.subscribe(Event.TreeOpen, align_float_right)
      api.events.subscribe(Event.TreeRendered, align_float_right)
      -- api.events.subscribe(Event.Resize, align_float_right)
    end
  end
}
