------------------------------------------------------------
-- Buffer Only CMD
------------------------------------------------------------

local function buffer_only(discard_modified_buffers)
  vim.cmd("silent! tabonly!")

  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_buffer_ft = vim.api.nvim_get_option_value("filetype", { buf = current_buffer })

  if current_buffer_ft == "NvimTree" or current_buffer_ft == "dbui" or current_buffer_ft == "dbout" then
    return vim.notify(current_buffer_ft, vim.log.levels.INFO)
  end

  for _, buffer in ipairs(buffers) do
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })
    local stopper = buffer == current_buffer or ft == "fzf" or ft == "minimap" or ft == "NvimTree" or ft == "dbui" or ft == "dbout" or not vim.api.nvim_buf_is_valid(buffer)

    if not stopper then
      if discard_modified_buffers then
        vim.api.nvim_buf_delete(buffer, { force = true })
      else
        if vim.api.nvim_get_option_value("modified", { buf = buffer }) then
          vim.api.nvim_set_option_value("buflisted", true, { buf = buffer })
        else
          vim.api.nvim_buf_delete(buffer, { force = false })
        end
      end
    end
  end
end

-- user command
vim.api.nvim_create_user_command("BufferOnly", function(opts) buffer_only(opts.bang) end, { bang = true })
