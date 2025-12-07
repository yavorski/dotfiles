--- @brief
--- UI for messages, cmdline, search and popupmenu

local Lazy = require("core/lazy")

--- @module "noice"
--- @type NoiceConfig
--- @diagnostic disable: missing-fields
local options = {
  notify = { view = "mini" },
  messages = { enabled = true },
  popupmenu = { enabled = false },
  cmdline_output = { enabled = true },
  cmdline = { view = "cmdline_popup" },

  --- @type table<string, NoiceCommand>
  commands = { history = { view = "popup" } },

  lsp = {
    hover = { enabled = false },
    message = { enabled = true },
    progress = { enabled = true },
    signature = { enabled = false },
    documentation = { enabled = false }
  },

  --- @type NoiceFormatOptions
  format = {
    level = {
      icons = { info = "▪", hint = "★", warn = "◮", error = "" }
    }
  },

  --- @type NoiceRouteConfig[]
  routes = {
    -- { view = "mini", filter = { event = "msg_showmode" } },
    { view = "popup", filter = { min_height = 7 } },
    { view = "popup", filter = { event = "msg_show", min_height = 7 } },
    { view = "split", filter = { cmdline = "^:", min_height = 7 } },
    { filter = { event = "lsp", kind = "progress", find = "GitHub Copilot", min_length = 17, max_length = 17 }, opts = { skip = true } },
  },

  --- @type NoiceConfigViews
  --- @type table<string, NoiceViewOptions>
  views = {
    split = { size = "24%" },
    notify = { merge = true, replace = true },
    messages = { view = "popup", enter = true },
    confirm = { position = { row = 5, col = "50%" } },
    popup = {
      size = { width = "78%", height = "60%" },
      border = { style = "rounded", padding = { 0, 1 } },
      win_options = { wrap = true }
    },
    cmdline_input = {
      border = { style = "rounded", padding = { 0, 1 } },
      -- win_options = { winhighlight = { Normal = "NoiceDark" } }
    },
    cmdline_popup = {
      align = "center",
      position = { row = 8, col = "50%" },
      size = { min_width = 82, max_width = 120 },
      border = { style = "rounded", padding = { 0, 1 } },
      -- win_options = { winhighlight = { Normal = "NoiceDark" } }
    },
    mini = {
      timeout = 2800,
      border = { style = "rounded", padding = { 0, 1 } },
      position = { row = 2, col = "97.5%" },
      -- win_options = { winhighlight = { Normal = "MiniNotifyNormal" } }
    }
  }
}

Lazy.use {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "muniftanjim/nui.nvim" },
  config = function()
    require("noice").setup(options)
    require("noice.config.format").builtin.lsp_progress_done[1] = { "  ", hl_group = "NoiceLspProgressSpinner" }

    _G.d = function(...) vim.notify(vim.inspect(...), vim.log.levels.DEBUG) end
    vim.keymap.set({ "c" }, "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()); vim.api.nvim_input("<esc>") end)
  end
}
