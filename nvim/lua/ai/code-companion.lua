local Lazy = require("core/lazy")

Lazy.use {
  "olimorris/codecompanion.nvim",
  -- dir = "~/dev/open-sos/codecompanion.nvim",
  dependencies = {
    "github/copilot.vim",
    "echasnovski/mini.diff",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    { "<leader>cq", mode = { "n", "v" }, "<cmd>CodeCompanion<cr>", silent = true, desc = "CodeCompanion AI Prompt" },
    { "<leader>ca", mode = { "n", "v" }, "<cmd>CodeCompanionActions<cr>", silent = true, desc = "CodeCompanion Actions" },
    { "<leader>cc", mode = { "n", "v" }, "<cmd>CodeCompanionChat Toggle<cr>", silent = true, desc = "CodeCompanion Chat Toggle" },
  },
  opts = {
    adapters = {
      copilot_gpt4o = function() return require("codecompanion.adapters").extend("copilot", { schema = { model = { default = "gpt-4o" } } }) end,
      copilot_gpt41 = function() return require("codecompanion.adapters").extend("copilot", { schema = { model = { default = "gpt-4.1" } } }) end,
    },
    strategies = {
      inline = {
        adapter = "copilot",
        keymaps = {
          accept_change = { modes = { n = "<C-a>", x = "<C-a>" } },
          reject_change = { modes = { n = "<C-r>", x = "<C-r>" } },
        }
      },
      chat = {
        adapter = "copilot_gpt41",
        keymaps = {
          send = { modes = { n = "<CR>", i = "<C-CR>" } },
          close = { modes = { n = "<C-q>", i = "<C-q>" } },
        }
      }
    },
    display = {
      -- inline = { layout = "buffer" },
      diff = {
        provider = "mini_diff"
      },
      chat = {
        show_settings = true,
        show_header_separator = true,
        window = {
          opts = {
            signcolumn = "yes",
            relativenumber = false
          }
        }
      },
      action_palette = {
        prompt = "[AI] Prompt",
        provider = "default", -- default is working with fzf_lua vertical layout
        opts = {
          show_default_actions = true,
          show_default_prompt_library = true,
        }
      }
    }
  }
}
