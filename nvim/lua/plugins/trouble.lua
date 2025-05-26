--- @brief
--- Diagnostics, references, fzf-lua/telescope results, quickfix and location list

local Lazy = require("core/lazy")

Lazy.use {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  keys = {
    { "<A-t>", "<cmd>Trouble<CR>", silent = true, desc = "Trouble" },
    { "<A-ESC>", "<cmd>Trouble close<CR>", silent = true, desc = "Trouble close" },
    { "<A-F13>", "<cmd>Trouble close<CR>", silent = true, desc = "Trouble close" },
    { "<A-[>", "<cmd>Trouble prev skip_groups=true jump=true<CR>", silent = true, desc = "Trouble prev" },
    { "<A-]>", "<cmd>Trouble next skip_groups=true jump=true<CR>", silent = true, desc = "Trouble next" },
  },
  --- @module "trouble"
  --- @type trouble.Config
  opts = {
    auto_open = false, -- auto open when there are items
    auto_close = true, -- auto close when there are no items
    auto_preview = true, -- automatically open preview when on an item
    auto_refresh = false, -- auto refresh when open
    auto_jump = true, -- auto jump to the item when there's only one
    focus = false, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = true, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    preview = { border = "none" }, -- override winborder
    modes = {
      lsp_base = { params = { include_current = true } },
      lsp_references = { params = { include_declaration = true } }
    }
  },
  config = function(_, options)
    require("trouble").setup(options)
    require("fzf-lua.config").defaults.actions.files["alt-t"] = require("trouble.sources.fzf").actions.open
  end,
  init = function()
    vim.api.nvim_create_user_command("TroubleFocus", "Trouble focus", { desc = "Trouble Focus" })
    vim.api.nvim_create_user_command("TroubleClose", "Trouble close", { desc = "Trouble Close" })
  end
}
