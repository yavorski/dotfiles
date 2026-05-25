--- @brief
--- @module "lsp-overloads"
--- https://github.com/Issafalcon/lsp-overloads.nvim
--- Extends native nvim-lsp handlers to allow easier navigation through method overloads

local Lazy = require("core/lazy")
local window_border = require("core/border")

--- @type lsp-overloads.Config
--- @diagnostic disable: missing-fields
local options = {
  ui = {
    wrap = true,
    silent = false,
    focusable = true,
    border = window_border,
    floating_window_above_cur_line = false,
    close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
  },
  keymaps = {
    scroll_up = "<C-u>",
    scroll_down = "<C-d>",
    next_signature = "<A-n>",
    close_signature = "<A-o>",
    previous_signature = "<A-p>",
    next_parameter = "<A-l>",
    previous_parameter = "<A-h>",
  },
  display_automatically = false,
  override_native_handler = false,
}

--- Return the floating window id of an open signature popup.
local function signature_win()
  local win = vim.b.lsp_floating_preview
  if win and vim.api.nvim_win_is_valid(win) and vim.w[win]["textDocument/signatureHelp"] then
    return win
  end
  return nil
end

local function open_signature()
  if not signature_win() then
    require("blink.cmp.signature.trigger").hide()
    vim.cmd("LspOverloads signature")
  end
end

local function close_signature()
  local win = signature_win()
  if win then
    vim.api.nvim_win_close(win, true)
    return
  end
end

local function toggle_signature()
  if signature_win() then
    close_signature()
  else
    open_signature()
  end
end

--- Build a mode-agnostic nav callback for the given lhs.
---@param lhs string The key sequence (e.g. "<A-n>")
---@return fun() callback
local function navigate_overloads(lhs)
  return function()
    if not signature_win() then
      open_signature()
      return
    end

    -- Look up the plugin's buffer-local insert-mode mapping.
    -- maparg with {dict=true} returns a table including the `callback` field
    local m = vim.fn.maparg(lhs, "i", false, true)
    if type(m) == "table" and type(m.callback) == "function" then
      m.callback()
    end
  end
end

Lazy.use {
  "issafalcon/lsp-overloads.nvim",
  event = "LspAttach",
  config = function()
    require("lsp-overloads").setup(options)
  end,
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      -- pattern = { "*.cs" },
      group = vim.api.nvim_create_augroup("local/lsp-overloads", { clear = true }),
      callback = function(event)
        local buf = event.buf

        vim.keymap.set({ "n", "i", "s" }, "<A-o>", toggle_signature, { buffer = buf, silent = true, desc = "LSP Toggle Signature" })

        -- opens the signature popup if it is closed
        for _, lhs in ipairs({ "<A-n>", "<A-p>", "<A-l>", "<A-h>" }) do
          vim.keymap.set({ "n", "i", "s" }, lhs, navigate_overloads(lhs), { buffer = buf, silent = true })
        end
      end
    })
  end
}
