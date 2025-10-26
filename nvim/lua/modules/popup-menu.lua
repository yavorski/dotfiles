------------------------------------------------------------
-- Popup Menu Keymaps
-- Accept with <C-e>
-- Cancel/Revert with <C-c>
------------------------------------------------------------

local PUM = {
  is_canceled = false,
  is_listener_attached = false,
  namespace_id = vim.api.nvim_create_namespace("popup_menu_listener"),
  keys = {
    CTRL_C = vim.keycode("<C-c>"),
    CTRL_E = vim.keycode("<C-e>"),
    CTRL_Y = vim.keycode("<C-y>"),
  }
}

PUM.on_key = function(key)
  if vim.fn.pumvisible() ~= 1 then return end

  if key == PUM.keys.CTRL_C then
    PUM.is_canceled = true
    vim.api.nvim_feedkeys(PUM.keys.CTRL_E, "i", false)
    return ""
  elseif key == PUM.keys.CTRL_E and not PUM.is_canceled then
    vim.api.nvim_feedkeys(PUM.keys.CTRL_Y, "i", false)
    return ""
  end

  PUM.is_canceled = false
end

PUM.add_listener = function()
  if not PUM.is_listener_attached then
    vim.on_key(PUM.on_key, PUM.namespace_id)
    PUM.is_listener_attached = true
  end
end

PUM.remove_listener = function()
  if PUM.is_listener_attached then
    vim.on_key(nil, PUM.namespace_id)
    PUM.is_listener_attached = false
  end
end

-- Initialize PUM - add the event handler on popup open and remove it on close
PUM.init = function()
  vim.api.nvim_create_autocmd("CompleteChanged", { callback = PUM.add_listener })
  vim.api.nvim_create_autocmd("CompleteDone", { callback = PUM.remove_listener })
end

-- init
vim.schedule(PUM.init)
