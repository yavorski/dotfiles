------------------------------------------------------------
-- AutoComplete -- https://cmp.saghen.dev/
------------------------------------------------------------

local Lazy = require("core/lazy")
local Copilot = require("ai/copilot")
local system = require("core/system")

--- @module "blink.cmp"
--- @type blink.cmp.Config
local blink_config = {
  term = { enabled = false },
  signature = { enabled = true },

  fuzzy = {
    implementation = system.is_linux and "rust" or "lua"
  },

  sources = {
    default = { "lsp", "path", "buffer" },
    per_filetype = {
      sql = { "dadbod", "buffer" },
      codecompanion = { "codecompanion" },
    },
    providers = {
      lsp = {
        name = "LSP",
        fallbacks = {},
        score_offset = 1024,
        should_show_items = function(_, items)
          -- remove always suggested closing tag by html server
          return not (#items == 1 and vim.tbl_contains({ "html", "razor", "cshtml", "htmlangular" }, vim.bo.filetype) and vim.startswith(items[1].label, "</"))
        end,
        transform_items = function(_, items)
          -- filter out text items and html closing tags
          return vim.tbl_filter(function(item) return item.kind ~= 1 and not vim.startswith(item.label, "</") end, items)
        end,
      },
      path = { max_items = 10, score_offset = 512 },
      buffer = { max_items = 10, score_offset = 256 },
      snippets = { max_items = 128, score_offset = 128 },
      dadbod = { module = "vim_dadbod_completion.blink", fallbacks = { "buffer", "snippets" } }
    },
    min_keyword_length = function()
      return vim.tbl_contains({ "html", "razor", "cshtml", "htmlangular", "markdown" }, vim.bo.filetype) and 1 or 0
    end
  },

  completion = {
    menu = {
      max_height = 18,
      draw = { align_to = "none" },
      auto_show = function(context, items)
        return not (Copilot.is_enabled() and Copilot.is_active())
      end
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = true
      }
    },
    accept = {
      auto_brackets = {
        enabled = true
      }
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 256,
      update_delay_ms = 128,
      window = {
        min_width = 64,
        max_width = 128,
        max_height = 32,
        desired_min_width = 64,
      }
    },
    keyword = { range = "prefix" },
    ghost_text = {
      enabled = function()
        return not (Copilot.is_enabled() and Copilot.is_active())
      end
    }
  },

  keymap = {
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-e>"] = { "select_and_accept", "fallback" },
    ["<C-y>"] = { "select_and_accept", "fallback" },
    ["<C-a>"] = { "hide", "fallback" },
    ["<C-c>"] = { "cancel", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<A-n>"] = { "select_next", "fallback" },
    ["<A-p>"] = { "select_prev", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-space>"] = { "show", "hide", --[[ "show_documentation", "hide_documentation" ]] },
    ["<C-S-space>"] = { function(cmp) cmp.show({ providers = { "snippets" } }) end, "hide" },
  },

  cmdline = {
    enabled = true,
    completion = {
      menu = { auto_show = false },
      ghost_text = { enabled = true },
    },
    keymap = {
      preset = "none",
      ["<C-e>"] = { "select_and_accept", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<C-a>"] = { "cancel", "fallback_to_mappings" },
      ["<C-c>"] = { "cancel", "fallback", "fallback_to_mappings" },
      ["<C-w>"] = { "cancel", "fallback", "fallback_to_mappings" },
      ["<C-n>"] = { "show_and_insert", "select_next", "fallback" },
      ["<C-p>"] = { "show_and_insert", "select_prev", "fallback" },
      ["<Tab>"] = { "show_and_insert", "select_next", "fallback" },
      ["<S-Tab>"] = { "show_and_insert", "select_prev", "fallback" },
      ["<C-space>"] = { "show", "hide", "fallback" },
    }
  }
}

Lazy.use {
  "saghen/blink.cmp",
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = blink_config,
  opts_extend = { "sources.default" }
}
