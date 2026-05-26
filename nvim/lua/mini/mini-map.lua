--- @brief
--- minimap - window with buffer text overview

local Lazy = require("core/lazy")

--- mini map git-signs staged hunks integration
local function git_signs_staged_hunks_integration()
  local hl_groups = {
    add = "GitSignsStagedAdd",
    change = "GitSignsStagedChange",
    delete = "GitSignsStagedDelete",
  }

  -- Set up autocommand to refresh map when gitsigns updates
  local augroup = vim.api.nvim_create_augroup("MiniMapGitsignsStaged", {})
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "GitSignsUpdate",
    callback = function()
      if MiniMap ~= nil then
        MiniMap.refresh(nil, { lines = false, scrollbar = false, integrations = true })
      end
    end,
    desc = "Refresh MiniMap on GitSignsUpdate for staged hunks"
  })

  -- Return the integration function
  return function()
    local bufnr = MiniMap.current.buf_data.source
    if not bufnr then return {} end

    -- Get staged hunks from gitsigns cache using the internal method
    local has_cache, gsc = pcall(require, "gitsigns.cache")
    if not has_cache or not gsc or not gsc.cache then return {} end

    local cache_entry = gsc.cache[bufnr]
    if not cache_entry then return {} end

    -- Use the cache entry's get_hunks method with staged=true
    local hunks_staged = cache_entry:get_hunks(nil, true)
    if not hunks_staged then return {} end

    -- Convert to line highlights - same as H.hunks_to_line_hl in mini.map
    local res = {}
    for _, h in ipairs(hunks_staged) do
      local from_line = h.added.start
      local n_added, n_removed = h.added.count, h.removed.count
      local n_lines = math.max(n_added, 1)

      for i = 1, n_lines do
        local hl_type = (n_added < i and "delete") or (i <= n_removed and "change" or "add")
        local hl_group = hl_groups[hl_type]
        if hl_group then
          table.insert(res, { line = from_line + i - 1, hl_group = hl_group })
        end
      end
    end

    return res
  end
end

--- minimal scrollbar only
local function setup_minimal()
  local map = require("mini.map")
  local options = {
    integrations = nil,
    window = {
      width = 1,
      winblend = 25,
      show_integration_count = false
    },
    symbols = {
      scroll_line = "┃",
      scroll_view = "┃",
    }
  }

  map.setup(options)
  map.open(options)
end

--- map with git integrations
local function setup_with_features()
  local map = require("mini.map")
  local options = {
    integrations = {
      map.gen_integration.gitsigns(),
      git_signs_staged_hunks_integration()
    },
    window = {
      width = 11,
      winblend = 25,
      show_integration_count = false
    },
    symbols = {
      scroll_line = "┃",
      scroll_view = "┃",
      encode = map.gen_encode_symbols.dot("4x2")
    }
  }

  map.setup(options)
  map.open(options)
end

local minimal = true
local function toggle()
  if minimal then
    setup_with_features()
    minimal = false
  else
    setup_minimal()
    minimal = true
  end
end

Lazy.use {
  "nvim-mini/mini.map",
  event = "VeryLazy",
  config = function()
    setup_minimal()
    -- vim.keymap.set("n", "<leader>X", toggle, { desc = "MiniMap Toggle" })
    vim.api.nvim_create_user_command("MiniMapToggle", toggle, { desc = "MiniMap Toggle" })
  end
}
