--- @brief
--- @module "codecompanion"
--- https://codecompanion.olimorris.dev/

local Lazy = require("core/lazy")

Lazy.use {
  "olimorris/codecompanion.nvim",
  -- dir = "~/dev/open-sos/codecompanion.nvim",
  dependencies = {
    "github/copilot.vim",
    "nvim-mini/mini.diff",
    "nvim-lua/plenary.nvim",
    { "nvim-treesitter/nvim-treesitter", branch = "main" }
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions"
  },
  keys = {
    { "<leader>cq", mode = { "n", "v" }, "<cmd>CodeCompanion<cr>", silent = true, desc = "CodeCompanion AI Prompt" },
    { "<leader>ca", mode = { "n" }, "<cmd>CodeCompanionActions<cr>", silent = true, desc = "CodeCompanion Actions" },
    { "<leader>ca", mode = { "v" }, "<cmd>CodeCompanionChat Add<cr>", silent = true, desc = "CodeCompanion Add to Chat" },
    { "<leader>cc", mode = { "n", "v" }, "<cmd>CodeCompanionChat Toggle<cr>", silent = true, desc = "CodeCompanion Chat Toggle" },
  },
  opts = {
    strategies = {
      inline = {
        -- adapter = "copilot",
        adapter = {
          name = "copilot",
          model = "claude-sonnet-4",
        },
        keymaps = {
          accept_change = { modes = { n = "<C-a>", x = "<C-a>" } },
          reject_change = { modes = { n = "<C-r>", x = "<C-r>" } },
        }
      },
      chat = {
        -- adapter = "copilot",
        adapter = {
          name = "copilot",
          model = "claude-sonnet-4",
        },
        keymaps = {
          send = { modes = { n = "<CR>", i = "<C-CR>" } },
          close = { modes = { i = "<C-q>", n = { "<C-q>", "<leader>e", "<leader>q" } } },
          -- super_diff = { modes = { n = "gD" } },
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

--- treesitter for chat buffers
--- NOTE remove when this PR is merged
--- https://gh.io/olimorris/codecompanion.nvim/pull/1547
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChatCreated",
  group = vim.api.nvim_create_augroup("my-codecompanion-chat", { clear = true }),
  callback = function(event)
    vim.treesitter.start(event.data.bufnr, "markdown")
  end
})
