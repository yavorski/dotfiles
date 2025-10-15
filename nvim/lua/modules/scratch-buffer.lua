--- @brief Scratch Buffer Plugin
--- Fast toggle floating window for quick notes or todos
--- Saved automatically per cwd in '~/.local/share/nvim/scratch'

local window_border = require("core/border")

local M = {}

local defaults = {
  width = 160,
  height = 32,
  filetype = "markdown",
  extension = "md",
  autowrite = true,
  border = window_border,
  root = vim.fn.stdpath("data") .. "/scratch",
}

local scratch_buf = nil
local scratch_win = nil

---@param buf integer?
---@return boolean
local function is_valid_buf(buf)
  return buf ~= nil and vim.api.nvim_buf_is_valid(buf)
end

---@param win integer?
---@return boolean
local function is_valid_win(win)
  return win ~= nil and vim.api.nvim_win_is_valid(win)
end

--- get buffer file path
---@return string
local function get_file()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local filename = string.format("%s.scratch.%s", cwd, defaults.extension)
  return defaults.root .. "/" .. filename
end

--- setup buf - load from disk or create new buf if it does not exists
---@return integer
local function set_buf()
  local file = get_file()
  local file_exists = vim.uv.fs_stat(file) ~= nil
  local buf = nil

  if file_exists then
    buf = vim.fn.bufadd(file)
    vim.fn.bufload(buf)
  else
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, file)
  end

  return buf
end

---@param buf integer
local function set_buf_options(buf)
  vim.bo[buf].buftype = ""
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = defaults.filetype
end

--- setup auto save
---@param buf integer
local function set_autowrite(buf)
  if not defaults.autowrite or not is_valid_buf(buf) then
    return
  end

  vim.api.nvim_create_autocmd("BufHidden", {
    desc = "Scratch Auto Save",
    group = vim.api.nvim_create_augroup(string.format("scratch-buffer-%s", buf), {}),
    buffer = buf,
    callback = function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent! TrimTrailingWhiteSpace")
          vim.cmd("silent! write")
        end)
      end
    end
  })
end

--- Make the scratch buffer with all options
---@return integer
local function make_scratch_buf()
  if is_valid_buf(scratch_buf) then
    return scratch_buf
  end

  local buf = set_buf()
  set_buf_options(buf)
  set_autowrite(buf)

  return buf
end

--- Make floating window for the scratch buffer
---@return integer
local function make_float_win(buf)
  if not is_valid_buf(buf) then
    error(string.format("Invalid scratch buffer (bufnr: %s, type: %s)", tostring(buf), type(buf)))
  end

  local width = defaults.width
  local height = defaults.height

  local win_width = vim.o.columns
  local win_height = vim.o.lines

  local row = math.floor((win_height - height) / 2) - 4
  local col = math.floor((win_width - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = defaults.border,
    title_pos = "center",
    title = " [ Scratch Buffer ] "
  })

  vim.wo[win].rnu = false
  vim.wo[win].number = true
  vim.wo[win].winfixbuf = true
  vim.wo[win].winfixheight = true
  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

  vim.keymap.set("n", "q", M.close, { buffer = buf, desc = "Scratch Close" })
  vim.keymap.set("n", "<C-q>", M.close, { buffer = buf, desc = "Scratch Close" })
  vim.keymap.set("n", "<leader>q", M.close, { buffer = buf, desc = "Scratch Close" })

  vim.api.nvim_create_autocmd("WinClosed", {
    once = true,
    group = vim.api.nvim_create_augroup(string.format("scratch-buffer-window-%s", win), {}),
    pattern = tostring(win),
    callback = function()
      scratch_win = nil
    end
  })

  return win
end

---@param win integer
---@return boolean
local function is_win_in_current_tab(win)
  if not is_valid_win(win) then
    return false
  end

  local win_tab = vim.api.nvim_win_get_tabpage(win)
  local current_tab = vim.api.nvim_get_current_tabpage()

  return win_tab == current_tab
end

------------------------------------------------------------
-- Plugin API
------------------------------------------------------------

function M.open()
  scratch_buf = make_scratch_buf()
  scratch_win = make_float_win(scratch_buf)
end

function M.close()
  if is_valid_win(scratch_win) then
    vim.api.nvim_win_close(scratch_win, false)
    scratch_win = nil
  end
end

function M.toggle()
  if scratch_win == nil then
    M.open()
  else
    if is_win_in_current_tab(scratch_win) then
      M.close()
    else
      -- reopen if we are in another tab
      M.close()
      M.open()
    end
  end
end

function M.init()
  vim.fn.mkdir(defaults.root, "p")
  vim.keymap.set("n", "<leader>s", M.toggle, { desc = "Scratch Toggle" })
  vim.api.nvim_create_user_command("ScratchToggle", M.toggle, { desc = "Scratch Toggle" })
end

-- setup
vim.schedule(M.init)
