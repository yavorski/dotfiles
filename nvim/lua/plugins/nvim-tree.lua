--- @brief
--- File explorer tree sidebar

local Lazy = require("core/lazy")
local window_border = require("core/border")

Lazy.use {
  "nvim-tree/nvim-tree.lua",
  cmd = "NvimTreeToggle",
  opts = {
    git = { timeout = 2048 },
    sync_root_with_cwd = true,
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
  },
  keys = {
    { [[<leader>\r]], "<cmd>NvimTreeRefresh<cr>", silent = true, desc = "NvimTreeRefresh" },
    { [[<leader>\f]], "<cmd>NvimTreeFindFile<cr>", silent = true, desc = "NvimTreeFindFile" },
    { [[<leader>\F]], "<cmd>NvimTreeFindFile!<cr>", silent = true, desc = "NvimTreeFindFile!" },
    { [[<leader>\\]], function() require("nvim-tree.api").tree.toggle({ focus = false }) end, silent = true, desc = "NvimTreeToggle" },
  }
}
