--- @brief Route LSP progress events through `nvim_echo` as `kind = "progress"`.

local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup("local/lsp-progress-messages", { clear = true })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = augroup,
    callback = function(ev)
      local value = ev.data and ev.data.params and ev.data.params.value
      if type(value) ~= "table" then return end

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end

      -- Skip empty "GitHub Copilot" progress heartbeats
      if value.title == "GitHub Copilot" and not value.message then
        return
      end

      local is_end = value.kind == "end"
      local detail = value.message or value.title or (is_end and "done" or "")
      local text = client.name .. (detail ~= "" and (": " .. detail) or "")

      vim.api.nvim_echo({ { text } }, false, {
        id = "lsp." .. ev.data.client_id,
        kind = "progress",
        source = "vim.lsp",
        title = value.title,
        status = is_end and "success" or "running",
        percent = value.percentage,
      })
    end
  })
end

return M
