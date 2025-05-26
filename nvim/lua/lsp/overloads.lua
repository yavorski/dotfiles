--- @brief
--- https://github.com/Issafalcon/lsp-overloads.nvim
--- Extends native nvim-lsp handlers to allow easier navigation through method overloads

local Lazy = require("core/lazy")
local window_border = require("core/border")

--- @module "lsp-overloads"
--- @type LspOverloadsSettings
--- @diagnostic disable: missing-fields
local options = {
  silent = true,
  display_automatically = false,
  ui = {
    silent = true,
    border = window_border
  },
  keymaps = {
    next_signature = "<A-n>",
    previous_signature = "<A-p>",
    close_signature = "<A-o>",
  }
}

local function toggle()
  vim.cmd("LspOverloadsSignature");
  require("blink.cmp.signature.trigger").hide()
end

local cache = {}
local function setup()
  local init = false
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/signatureHelp" })

  if #clients == 0 then
    vim.notify("No signature help!")
    return
  end

  for _, client in ipairs(clients) do
    if not cache[client.id] then
      init = true
      cache[client.id] = true
      require("lsp-overloads").setup(client, options)
    end
  end

  if init then
    toggle()
    vim.keymap.set({ "n", "i", "s" }, "<A-o>", toggle, { buffer = true, silent = true, desc = "LSP Toggle" })
  end
end

Lazy.use {
  "issafalcon/lsp-overloads.nvim",
  keys = {{ "<A-o>", setup, mode = { "n", "i", "s" }, desc = "LSP Overloads" }},
}
