--- @brief
--- @module "nvim-tree"
--- File explorer tree - sidebar or floating window

local Lazy = require("core/lazy")
local window_border = require("core/border")

local FLOAT = true
local PINNED = true
local FLOAT_OFFSET = 4
local MIN_WIDTH = FLOAT and 42 or 30
local ATTACHED_FLOAT_EVENTS = false

-- get nvim-tree opts
local function options()
  MIN_WIDTH = FLOAT and 42 or 30

  return {
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
        quit_on_focus_loss = not PINNED,
        open_win_config = {
          col = vim.o.columns - MIN_WIDTH - FLOAT_OFFSET, -- align to right
          height = vim.o.lines - FLOAT_OFFSET, -- use full height
          zindex = 1, -- stay under other floating windows
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
end

-- don't let other buffers to sneak in nvim-tree window
local function prevent_window_takeover()
  local api = require("nvim-tree.api")

  api.events.subscribe(api.events.Event.TreeOpen, function()
    vim.api.nvim_set_option_value("winfixbuf", true, { scope = "local", win = api.tree.winid() })
    vim.api.nvim_set_option_value("winfixheight", true, { scope = "local", win = api.tree.winid() })
  end)
end

-- keep menu aligned to the right
local function align_float_right()
  if not FLOAT then
    return
  end

  local api = require("nvim-tree.api")

  if not api.tree.is_visible() then
    return
  end

  local winid = api.tree.winid()
  local config = vim.api.nvim_win_get_config(winid)
  local desired_column = vim.o.columns - config.width - FLOAT_OFFSET

  if desired_column ~= config.col then
    config.col = desired_column
    vim.api.nvim_win_set_config(winid, config)
  end
end

-- keep menu aligned to the right
local function attach_float_events()
  if not FLOAT then return end
  if ATTACHED_FLOAT_EVENTS then return end

  local api = require("nvim-tree.api")

  api.events.subscribe(api.events.Event.TreeOpen, align_float_right)
  api.events.subscribe(api.events.Event.TreeRendered, align_float_right)

  ATTACHED_FLOAT_EVENTS = true
end

-- toggle pin or float state
local function toggle(pin_or_float)
  local api = require("nvim-tree.api")
  local is_visible = api.tree.is_visible()
  local is_focused = is_visible and api.tree.is_tree_buf(0)

  if pin_or_float == "pin" then
    PINNED = not PINNED
  end

  if pin_or_float == "float" then
    FLOAT = not FLOAT
    attach_float_events()
  end

  require("nvim-tree").setup(options())

  if is_visible then
    -- open is not respecting focus param
    api.tree.toggle({ focus = is_focused })
  end
end

Lazy.use {
  "nvim-tree/nvim-tree.lua",
  -- dir = "~/dev/open-sos/nvim-tree.lua",
  cmd = {
    "NvimTreeOpen",
    "NvimTreeToggle"
  },
  keys = {
    { [[<leader>\r]], "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { [[<leader>\f]], "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { [[<leader>\F]], "<cmd>NvimTreeFindFile!<cr>", silent = true, desc = "NvimTreeFindFile!" },
    { [[<leader>\\]], function() require("nvim-tree.api").tree.toggle({ focus = FLOAT }) end, silent = true, desc = "NvimTreeToggle" },
  },
  config = function()
    attach_float_events()
    prevent_window_takeover()
    require("nvim-tree").setup(options())
    vim.api.nvim_create_user_command("NvimTreeTogglePin", function() toggle("pin") end, { desc = "Toggle nvim-tree pin state" })
    vim.api.nvim_create_user_command("NvimTreeToggleFloat", function () toggle("float") end, { desc = "Toggle nvim-tree float state" })
  end
}
