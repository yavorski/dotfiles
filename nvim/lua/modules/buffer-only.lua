------------------------------------------------------------
-- Buffer Only CMD
------------------------------------------------------------

local PROTECTED_FILETYPES = {
  fzf = true,
  dbui = true,
  dbout = true,
  minimap = true,
  NvimTree = true,
}

--- Closes all buffers except the current one, with special handling for protected filetypes
--- @param force_close boolean If true, force delete modified buffers without saving
local function buffer_only(force_close)
  vim.cmd("silent! tabonly!")

  local buffers = vim.api.nvim_list_bufs()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_filetype = vim.bo[current_buffer].filetype

  if PROTECTED_FILETYPES[current_filetype] then
    return vim.notify(current_filetype, vim.log.levels.INFO)
  end

  for _, buffer in ipairs(buffers) do
    local bt = vim.bo[buffer].buftype
    local ft = vim.bo[buffer].filetype

    if buffer == current_buffer or PROTECTED_FILETYPES[ft] or not vim.api.nvim_buf_is_valid(buffer) then
      goto continue
    end

    if force_close or bt == "terminal" then
      vim.api.nvim_buf_delete(buffer, { force = true })
    elseif vim.bo[buffer].modified then
      vim.bo[buffer].buflisted = true
    else
      vim.api.nvim_buf_delete(buffer, { force = false })
    end

    ::continue::
  end
end

-- user command
vim.api.nvim_create_user_command("BufferOnly", function(opts) buffer_only(opts.bang) end, { bang = true })
