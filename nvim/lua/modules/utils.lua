local M = {}

M.close_empty_splits = function()
  pcall(function()
    vim.cmd([[ windo if line('$') == 1 && getline(1) == '' && bufname('%') == '' | close | endif ]])
  end)
end

-- Close/Delete "No Name" buffers
M.close_no_name_buffers = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local buf_type = vim.bo[buf].buftype
      local buf_name = vim.api.nvim_buf_get_name(buf)

      if buf_name == "" and buf_type == "" then
        local line_count = vim.api.nvim_buf_line_count(buf)
        if line_count == 1 then
          local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
          if first_line == "" then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
    end
  end
end

M.close_empties = function()
  M.close_no_name_buffers()
  M.close_empty_splits()
end

return M
