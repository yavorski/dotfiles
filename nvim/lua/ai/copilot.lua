local Copilot = {
  word_term = vim.api.nvim_replace_termcodes("<Plug>(copilot-accept-word)", true, true, true),
  line_term = vim.api.nvim_replace_termcodes("<Plug>(copilot-accept-line)", true, true, true),
}

Copilot.enable = function()
  vim.cmd("Copilot enable")
  vim.g.copilot_enabled = true
  vim.notify("Copilot: Enabled")
end

Copilot.disable = function()
  vim.cmd("Copilot disable")
  vim.g.copilot_enabled = false
  vim.notify("Copilot: Disabled")
end

Copilot.toggle = function()
  if vim.g.copilot_enabled then
    Copilot.disable()
    Copilot.buf_disable()
  else
    Copilot.enable()
    Copilot.buf_enable()
  end
end

Copilot.buf_enable = function()
  if vim.g.copilot_enabled then
    vim.b.copilot_enabled = true
    -- vim.cmd[[silent! call copilot#Suggest()]]
  end
end

Copilot.buf_disable = function()
  vim.b.copilot_enabled = false
  vim.cmd[[silent! call copilot#Dismiss()]]
end

Copilot.accept_word = function()
  vim.b.completion = false
  vim.api.nvim_feedkeys(Copilot.word_term, "i", true)
  vim.schedule(function() vim.b.completion = true end)
end

Copilot.accept_line = function()
  vim.b.completion = false
  vim.api.nvim_feedkeys(Copilot.line_term, "i", true)
  vim.schedule(function() vim.b.completion = true end)
end

Copilot.is_active = function()
  local suggestion = vim.fn["copilot#GetDisplayedSuggestion"]()
  return suggestion ~= nil and suggestion.text ~= nil and suggestion.text ~= ""
end

Copilot.is_enabled = function()
  return vim.g.loaded_copilot and vim.g.copilot_enabled ~= false and vim.b.copilot_enabled ~= false
end

return Copilot
