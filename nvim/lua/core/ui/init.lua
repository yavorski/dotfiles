--- @brief
--- ui2 message-routing wrapper
--- See https://neovim.io/doc/user/lua/#_ui2
---
--- Behavior:
--- * Top-right "mini" message float for ephemeral notifications.
--- * Pager popup for large messages, `:messages`, `:history`, and verbose output.
--- * Press `g<` (Neovim built-in) to enter the pager.
--- * Filters noisy write-summary lines, undo/redo headers, and `bufwrite` events.
--- * Surfaces large yanks (>= 3 lines) as a notification.
--- * Kind-aware titles and highlights on message floats.
--- * LSP progress routed through `nvim_echo` with `kind = "progress"`.
--- * Cmdline is handled separately by ../../plugins/cmd-line.lua.
---
--- Submodules:
--- * config.lua        - constants (filters, kind → title map, sizing)
--- * util.lua          - helpers (content_to_text, valid_win, title_chunks)
--- * filter.lua        - should_skip predicate
--- * titles.lua        - per-target title state + kind → title resolution
--- * decorate.lua      - msg / pager / dialog float decorators
--- * search_count.lua  - [1/N] end-of-line virtual text
--- * wrap.lua          - wraps ui2.messages.{set_pos,msg_show,show_msg,msg_clear}
--- * lsp_progress.lua  - LspProgress → nvim_echo (kind = "progress")
--- * debug.lua         - global `d()` pretty-print helper

local ui2 = require("vim._core.ui2")
local config = require("core/ui/config")

ui2.enable({
  enable = true,
  msg = {
    targets = config.MSG_TARGETS,
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 2800 },
    pager = { height = 0.8 },
  },
})

require("core/ui/wrap").setup()
require("core/ui/search_count").setup()
require("core/ui/lsp_progress").setup()
require("core/ui/debug").setup()
