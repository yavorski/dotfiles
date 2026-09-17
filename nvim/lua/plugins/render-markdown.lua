--- @brief
--- Render markdown tables
--- :RenderMarkdown toggle - toggle rendering globally
--- :RenderMarkdown enable - enable rendering globally
--- :RenderMarkdown disable - disable rendering globally
--- :RenderMarkdown buf_toggle - toggle rendering for current buffer

local Lazy = require("core/lazy")

Lazy.use {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {{ "nvim-treesitter/nvim-treesitter", version = "main" }},
  -- ft = { "markdown" },
  cmd = { "RenderMarkdown" },
  --- @module "render-markdown"
  --- @type render.md.UserConfig
  opts = {
    render_modes = { "n", "c", "t", "v", "V", "\22" },
    anti_conceal = { enabled = false },
    win_options = {
      conceallevel = { default = vim.o.conceallevel, rendered = vim.o.conceallevel },
      concealcursor = { default = vim.o.concealcursor, rendered = vim.o.concealcursor },
    },
    bullet = { enabled = false },
    callout = {},
    checkbox = { enabled = false },
    code = { enabled = false },
    dash = { enabled = false },
    document = { enabled = false },
    heading = { enabled = false },
    html = { enabled = false },
    indent = { enabled = false },
    inline_highlight = { enabled = false },
    latex = { enabled = false },
    link = { enabled = false },
    paragraph = { enabled = false },
    quote = { enabled = false },
    sign = { enabled = false },
    yaml = { enabled = false },
    pipe_table = {
      enabled = true,
      preset = "round",
      style = "full",
      cell = "padded",
      alignment_indicator = "━",
    }
  }
}
