--- @brief
--- search_count → end-of-line virtual text
--- Neovim emits `kind = "search_count"` with payload like `[1/5]` via msg_show automatically — unless `S` is in `shortmess`.
--- Intercept that and render it as an extmark next to the cursor instead of through the msg float.

local M = {}

local NS = vim.api.nvim_create_namespace("ui2.search_count")

--- @type integer?
local cur_buf

--- @type integer?
local cur_extmark

function M.clear()
  if cur_extmark and cur_buf and vim.api.nvim_buf_is_valid(cur_buf) then
    pcall(vim.api.nvim_buf_del_extmark, cur_buf, NS, cur_extmark)
  end
  cur_extmark, cur_buf = nil, nil
end

--- @param text string like "[1/5]"
function M.show(text)
  text = vim.trim(text)
  if text == "" then
    M.clear()
    return
  end

  M.clear()

  local buf = vim.api.nvim_get_current_buf()

  -- Skip prompts / scratch / quickfix
  if vim.bo[buf].buftype ~= "" then return end

  local row = vim.api.nvim_win_get_cursor(0)[1] - 1

  local ok, id = pcall(vim.api.nvim_buf_set_extmark, buf, NS, row, 0, {
    virt_text = { { " " .. text, "DiagnosticVirtualTextInfo" } },
    virt_text_pos = "eol",
    hl_mode = "combine",
  })

  if ok then
    cur_extmark = id
    cur_buf = buf
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("local/ui-search", { clear = true })

  -- Clear when hlsearch goes off (e.g. `<C-l>`, `:nohlsearch`).
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "hlsearch",
    callback = function()
      if vim.v.hlsearch == 0 then M.clear() end
    end
  })

  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter", "TextChanged", "FileChangedShellPost" }, {
    group = group,
    callback = M.clear
  })
end

return M
