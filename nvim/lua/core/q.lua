--- @brief
--- Priority queue.
--- Sync items run before async.
--- Lower priority number runs first.

--- @class QueueItem
--- @field fn function
--- @field priority number
--- @field sync boolean

local M = {}
local DEFAULT_PRIORITY = 100

--- @type QueueItem[]
local sync_queue = {}

--- @type QueueItem[]
local async_queue = {}

--- @param fn function
--- @param opts? { sync?: boolean, enabled?: boolean, priority?: number }
function M.add(fn, opts)
  vim.validate("fn", fn, "function")
  opts = opts or {}

  if opts.enabled == false then
    return
  end

  local item = {
    fn = fn,
    priority = opts.priority or DEFAULT_PRIORITY,
    sync = opts.sync == true,
  }

  if item.sync then
    table.insert(sync_queue, item)
  else
    table.insert(async_queue, item)
  end
end

--- @param items QueueItem[]
local function sort_by_priority(items)
  table.sort(items, function(a, b)
    return a.priority < b.priority
  end)
end

local function drain()
  local sync_items = sync_queue
  local async_items = async_queue

  sync_queue = {}
  async_queue = {}

  sort_by_priority(sync_items)
  sort_by_priority(async_items)

  for _, item in ipairs(sync_items) do
    local ok, err = pcall(item.fn)
    if not ok then
      vim.notify("q: sync error: " .. tostring(err), vim.log.levels.ERROR)
    end
  end

  for _, item in ipairs(async_items) do
    local fn = item.fn
    vim.schedule(function()
      local ok, err = pcall(fn)
      if not ok then
        vim.notify("q: async error: " .. tostring(err), vim.log.levels.ERROR)
      end
    end)
  end
end

--- Call once in init.lua before VimEnter.
function M.setup()
  if vim.v.vim_did_enter == 1 then
    vim.schedule(drain)
  else
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("q.drain", { clear = true }),
      once = true,
      callback = drain,
    })
  end
end

return M
