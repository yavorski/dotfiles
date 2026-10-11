--- @brief
--- Window decorators for the ui2 msg / pager / dialog floats.

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local border = require("core/border")
local config = require("core/ui/config")
local util = require("core/ui/util")
local titles = require("core/ui/titles")

local M = {}

--- Decorate the pager or dialog float.
--- @param target "pager"|"dialog"
--- @param win integer?
function M.float(target, win)
  win = util.valid_win(win)

  if not win then
    return
  end

  if vim.api.nvim_win_get_config(win).hide then
    return
  end

  local title = util.title_chunks(titles.state[target])
  local cfg = {
    border = border,
    title = title,
    title_pos = title and "center" or nil,
  }

  if target == "dialog" then
    -- Above the tiny-cmdline float (plugins/cmd-line.lua).
    local cmd_row = math.floor(vim.o.lines * 0.20)
    local width = math.max(1, math.min(86, vim.o.columns - 4))
    local height = vim.api.nvim_win_get_height(win)
    cfg.relative = "editor"
    cfg.anchor = "NW"
    cfg.width = width
    cfg.height = height
    -- +2 for borders.
    cfg.col = math.floor((vim.o.columns - (width + 2)) / 2)
    cfg.row = math.max(0, cmd_row - height - 3)
    cfg.zindex = 250
  end

  pcall(vim.api.nvim_win_set_config, win, cfg)

  if target == "dialog" then
    -- Blocking prompts can ignore the first set_config; re-apply next tick
    -- (recomputed for resizes).
    vim.schedule(function()
      if not vim.api.nvim_win_is_valid(win) then
        return
      end
      local width = math.max(1, math.min(86, vim.o.columns - 4))
      local height = vim.api.nvim_win_get_height(win)
      cfg.width = width
      cfg.height = height
      cfg.col = math.floor((vim.o.columns - (width + 2)) / 2)
      cfg.row = math.max(0, math.floor(vim.o.lines * 0.20) - height - 3)
      pcall(vim.api.nvim_win_set_config, win, cfg)
      vim.cmd("redraw")
    end)
  end
end

--- Top-right mini-notify float.
--- @param win integer?
function M.msg(win)
  win = util.valid_win(win)

  if not win then
    return
  end

  if vim.api.nvim_win_get_config(win).hide then
    return
  end

  -- ui2 width only grows; measure content so the float can shrink.
  local buf = vim.api.nvim_win_get_buf(win)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content_width = 0
  for _, line in ipairs(lines) do
    local w = vim.api.nvim_strwidth(line)
    if w > content_width then
      content_width = w
    end
  end

  local max_width = math.floor(vim.o.columns * config.PAGER_WIDTH_RATIO)
  local width = math.max(math.min(content_width, max_width), config.MSG_MIN_WIDTH)
  local title = util.title_chunks(titles.state.msg)

  vim.api.nvim_win_set_config(win, {
    relative = "editor",
    anchor = "NE",
    row = 1,
    col = vim.o.columns - 3,
    width = width,
    border = border,
    title = title,
    title_pos = title and "center" or nil,
  })

  -- Sync ui2's width so it doesn't re-expand on the next indicator.
  if msgs.msg then
    msgs.msg.width = width
  end
end

function M.all()
  M.msg(ui2.wins.msg)
  M.float("pager", ui2.wins.pager)
  M.float("dialog", ui2.wins.dialog)
end

return M
