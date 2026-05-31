--- @brief
--- Route LSP progress events through `nvim_echo` as `kind = "progress"`.

local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup("local/lsp-progress-messages", { clear = true })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = augroup,
    callback = function(ev)
      if not (ev.data and ev.data.client_id) then return end

      local value = ev.data.params and ev.data.params.value
      if type(value) ~= "table" then return end

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end

      local kind = value.kind
      local is_end = kind == "end"
      local detail = value.message or value.title or (is_end and "done" or "")
      local text = client.name .. (detail ~= "" and (": " .. detail) or "")

      -- LSP spec only defines begin/report/end; some servers signal
      -- cancellation via `value.cancellable` flips or non-standard kinds.
      local status
      if kind == "end" then
        status = (value.cancelled or value.cancellable == false and value.message and value.message:lower():match("cancel")) and "cancelled" or "success"
      else
        status = "running"
      end

      vim.api.nvim_echo({ { text } }, false, {
        id = "lsp." .. ev.data.client_id,
        kind = "progress",
        source = "vim.lsp",
        title = value.title,
        status = status,
        percent = value.percentage,
      })
    end
  })
end

return M
