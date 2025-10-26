--- @brief
--- @module "multicursor-nvim"
--- Multiple cursors
--- https://github.com/jake-stewart/multicursor.nvim

local Lazy = require("core/lazy")

-- original function do not preserve the visual mode
local function matchAllAddCursorsVisual()
  local mc = require("multicursor-nvim")
  local prevCursorCount = 1
  local currentCursorCount = 1

  while true do
    mc.matchAddCursor(1)

    mc.action(function(ctx)
      currentCursorCount = ctx:numCursors()
    end)

    if currentCursorCount == prevCursorCount then
      break
    end

    prevCursorCount = currentCursorCount
  end
end

-- setup plugin
local function setup()
  local mc = require("multicursor-nvim")
  _G.MultiCursor = mc
  mc.setup()

  -- Add cursor to each line in visual selection
  vim.keymap.set({ "v", "x" }, "<A-v>", mc.visualToCursors, { desc = "[MC] Visual to Cursor" })

  -- Add or skip adding a new cursor by matching word/selection
  vim.keymap.set({ "v", "x" }, "<C-d>", function() mc.matchAddCursor(1) end, { desc = "[MC] Match Add Cursor" })
  vim.keymap.set({ "n", "x" }, "<A-d>", function() mc.matchAddCursor(1) end, { desc = "[MC] Match Add Cursor" })

  -- vim.keymap.set({ "n", "x" }, "<A-b>", function() mc.matchAddCursor(-1) end, { desc = "[MC] Match Add Cursor" })
  -- vim.keymap.set({ "n", "x" }, "<A-s>", function() mc.matchSkipCursor(1) end, { desc = "[MC] Match Skip Cursor" })

  -- Add a cursor for all matches of cursor word/selection in the document
  vim.keymap.set({ "n" }, "<A-m>", mc.matchAllAddCursors, { desc = "[MC] Match All Add Cursors" })
  vim.keymap.set({ "v", "x" }, "<A-m>", matchAllAddCursorsVisual, { desc = "[MC] Match All Add Cursors" })

  -- Add or skip cursor above/below the main cursor
  -- vim.keymap.set({ "n", "x" }, "<A-Up>", function() mc.lineAddCursor(-1) end)
  -- vim.keymap.set({ "n", "x" }, "<A-Down>", function() mc.lineAddCursor(1) end)

  -- Add a cursor to every search result in the buffer
  vim.keymap.set("n", "<A-/>", mc.searchAllAddCursors, { desc = "[MC] Search All Add Cursors" })

  -- Disable and enable cursors
  -- vim.keymap.set({ "n", "x" }, "<A-q>", mc.toggleCursor)

  -- Bring back cursors if accidentally cleared
  vim.keymap.set("n", "<A-u>", mc.restoreCursors, { desc = "[MC] Undo/Restore Cursors" })

  -- Mappings defined in a keymap layer only apply when there are multiple cursors
  mc.addKeymapLayer(function(layerSet)
    -- Append/Insert for each line of visual selections
    layerSet("x", "I", mc.insertVisual, { desc = "[MC] Insert Visual" })
    layerSet("x", "A", mc.appendVisual, { desc = "[MC] Append Visual" })

    -- Align cursor columns
    layerSet("n", "<A-a>", mc.alignCursors, { desc = "[MC] Align Cursors" })

    -- Select a different cursor as the main one
    layerSet({ "n", "x" }, "<A-j>", mc.nextCursor, { desc = "[MC] Next Cursor" })
    layerSet({ "n", "x" }, "<A-k>", mc.prevCursor, { desc = "[MC] Prev Cursor" })

    layerSet({ "n", "x" }, "<A-l>", mc.nextCursor, { desc = "[MC] Next Cursor" })
    layerSet({ "n", "x" }, "<A-h>", mc.prevCursor, { desc = "[MC] Prev Cursor" })

    -- Delete the main cursor
    layerSet({ "n", "x" }, "<A-x>", mc.deleteCursor, { desc = "[MC] Delete Cursor" })
  end)

  -- on toggle multi cursors
  -- toggle indentexpr mainly problematic in html filetypes
  mc.addKeymapLayer(function(layerSet)
    local indentexpr = vim.bo.indentexpr -- current
    vim.bo.indentexpr = "" -- clear/disable

    local function on_toggle()
      if mc.cursorsEnabled() then
        mc.clearCursors()
        vim.bo.indentexpr = indentexpr -- restore/enable
      else
        -- won't happen?
        mc.enableCursors()
      end
    end

    -- Enable and clear cursors using escape
    layerSet("n", "<esc>", on_toggle)
  end)
end

Lazy.use {
  "jake-stewart/multicursor.nvim",
  branch = "main",
  config = setup,
  keys = {
    { "<C-d>", mode = { "v", "x" } },
    { "<A-v>", mode = { "v", "x" } },
    { "<A-d>", mode = { "n", "v", "x" } },
    { "<A-b>", mode = { "n", "v", "x" } },
    { "<A-s>", mode = { "n", "v", "x" } },
    { "<A-m>", mode = { "n", "v", "x" } },
    { "<A-/>", mode = { "n" } },
  }
}
