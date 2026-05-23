--- @brief
--- mini.tabline

local Lazy = require("core/lazy")
local colors = require("colors/colors")

-- Map first char of vim.fn.mode() to a mode background color.
local mode_color_map = {
  n = colors.blue,
  i = colors.green,
  v = colors.softcyan,
  V = colors.softcyan,
  ["\22"] = colors.softcyan, -- <C-v> visual-block
  s = colors.yellow,
  S = colors.yellow,
  ["\19"] = colors.yellow, -- <C-s> select-block
  R = colors.red,
  c = colors.pink,
  t = colors.softpink,
}

local function current_mode_color()
  local m = vim.fn.mode()
  return mode_color_map[m] or mode_color_map[m:sub(1, 1)] or colors.blue
end

-- Apply mode-driven highlights for the active tab/buffer.
local function apply_tabline_hls()
  local mode_color = current_mode_color()

  -- MiniTablineCurrent: buffer is current (has cursor in it).
  vim.api.nvim_set_hl(0, "MiniTablineCurrent", { fg = colors.dark, bg = mode_color, bold = true })

  -- MiniTablineModifiedCurrent: buffer is modified and current.
  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { fg = colors.dark, bg = mode_color, bold = true, italic = true })

  -- MiniTablineVisible: buffer is visible (displayed in some window).
  vim.api.nvim_set_hl(0, "MiniTablineVisible", { fg = colors.text, bg = colors.surface1 })

  -- MiniTablineModifiedVisible: buffer is modified and visible.
  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { fg = colors.text, bg = colors.surface1, italic = true })

  -- MiniTablineHidden: buffer is hidden (not displayed).
  vim.api.nvim_set_hl(0, "MiniTablineHidden", { fg = colors.subtext0, bg = colors.dark })

  -- MiniTablineModifiedHidden: buffer is modified and hidden.
  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { fg = colors.overlay0, bg = colors.dark, italic = true })

  -- MiniTablineFill: unused right space of the tabline.
  vim.api.nvim_set_hl(0, "MiniTablineFill", { bg = colors.dark })

  -- MiniTablineTabpagesection: section with tabpage information (e.g. "Tab 1/3").
  vim.api.nvim_set_hl(0, "MiniTablineTabpagesection", { fg = colors.dark, bg = mode_color, bold = true })

  -- MiniTablineTrunc: truncation symbols indicating more left/right tabs.
  vim.api.nvim_set_hl(0, "MiniTablineTrunc", { fg = colors.overlay0, bg = colors.dark })
end

-- format title
local function format_title(buf_id, label)
  -- Replace the bare "*" unnamed-buffer label with "[No Name]"
  if label == "*" or label:match("^%*%(%d+%)$") then
    label = "[No Name]"
  end

  -- Prefix modified buffers with "^" to flag unsaved changes
  if vim.bo[buf_id].modified then
    label = label .. " ^"
  end

  return require("mini.tabline").default_format(buf_id, label)
end

local function init_tabline()
  require("mini.tabline").setup({
    format = format_title,
    tabpage_section = "right",
  })

  -- Always show a tabpage section
  -- mini.tabline omits it for #tabpages == 1
  local default_make = MiniTabline.make_tabline_string
  MiniTabline.make_tabline_string = function()
    local s = default_make()
    if #vim.api.nvim_list_tabpages() == 1 then
      local section = string.format(" Tab %d/%d ", vim.fn.tabpagenr(), vim.fn.tabpagenr("$"))
      s = s .. "%=%#MiniTablineTabpagesection#" .. section
    end
    return s
  end

  apply_tabline_hls()

  local gr = vim.api.nvim_create_augroup("local/tabline-mode", { clear = true })

  -- Refresh hls on mode change
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = gr,
    callback = function()
      apply_tabline_hls()
      vim.cmd.redrawtabline()
    end
  })

  -- Re-apply after colorscheme change
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = gr,
    callback = apply_tabline_hls,
  })
end

Lazy.use {
  "nvim-mini/mini.tabline",
  lazy = false,
  priority = 512,
  config = init_tabline,
}
