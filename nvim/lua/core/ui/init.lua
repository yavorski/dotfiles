--- @brief
--- ui2 message-routing wrapper
--- See https://neovim.io/doc/user/lua/#_ui2
---
--- * Mini msg float for ephemeral notifications; pager for large output, `:messages`,
---   `:history`, verbose. `g<` enters the pager.
--- * Filters write summaries, undo/redo headers, `bufwrite`; yanks surface at 3+ lines.
--- * Kind-aware float titles; LSP progress via `nvim_echo` (`kind = "progress"`).
--- * Cmdline lives in ../../plugins/cmd-line.lua.
---
--- Submodules:
--- * config.lua        - constants (filters, kind → title map, sizing)
--- * util.lua          - helpers (content_to_text, valid_win, title_chunks)
--- * filter.lua        - should_skip predicate
--- * routing.lua       - sink resolution mirroring upstream msg_show
--- * titles.lua        - per-target title state + kind → title resolution
--- * decorate.lua      - msg / pager / dialog float decorators
--- * search_count.lua  - [1/N] end-of-line virtual text
--- * wrap.lua          - wraps ui2.messages.{set_pos,msg_show,show_msg,msg_clear}
--- * lsp_progress.lua  - LspProgress → nvim_echo (kind = "progress")
--- * debug.lua         - global `d()` pretty-print helper

local ui2 = require("vim._core.ui2")
local config = require("core/ui/config")

-- 0.13: timeout lives in messagesopt (enable() rejects msg.msg.timeout).
local MSG_TIMEOUT = 3000
local has_013 = vim.fn.has("nvim-0.13") == 1

local opts = {
  enable = true,
  msg = {
    targets = config.MSG_TARGETS,
    dialog = { height = 0.5 },
    msg = { height = 0.5 },
    pager = { height = 0.8 },
  },
}

if has_013 then
  -- deny_duplicates: replace an existing timeout:, skip when already ours.
  local current = vim.opt.messagesopt:get().timeout
  if tostring(current) ~= tostring(MSG_TIMEOUT) then
    if current ~= nil then
      vim.opt.messagesopt:remove("timeout:" .. tostring(current))
    end
    vim.opt.messagesopt:append("timeout:" .. MSG_TIMEOUT)
  end
else
  opts.msg.msg.timeout = MSG_TIMEOUT -- legacy 0.12 enable() key
end

ui2.enable(opts)

-- Pre-5f7237f54b compat: singular cfg.msg.target is gone upstream; pin it on old builds.
-- No-op today (always nil).
if ui2.cfg.msg.target ~= nil then
  ui2.cfg.msg.target = "msg"
end

require("core/ui/wrap").setup()
require("core/ui/search_count").setup()
require("core/ui/lsp_progress").setup()
require("core/ui/debug").setup()
