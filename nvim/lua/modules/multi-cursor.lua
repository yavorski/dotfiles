--- @brief
--- Sublime like `<C-d>`: pin a cursor, jump to next match.
--- Wraps (even with `nowrapscan`); keeps intra-word column; never touches `@/`, `hlsearch`, or search history.
--- Jump runs with follow off (`2q=`), re-enabled after (`1q=`) so later edits follow. Wiped session restores via `gQ`.

--- @class McState state in `vim.b.mc`
--- @field word string|nil tracked `<cword>` (`nil` = free pattern)
--- @field pattern string explicit search pattern
--- @field offset integer intra-word column kept across jumps
--- @field landing [integer, integer]|nil primary pos after last jump

--- @class McSelection visual selection + start pos
--- @field text string selected text (`\n`-joined)
--- @field srow integer start row (1-indexed)
--- @field scol integer start col (1-indexed byte col)

--- `true`: obey ignorecase/smartcase. `false`: always ignore case.
--- @type boolean
local FOLLOW_SMARTCASE = true

--- Native multicursor extmark namespace
--- @type integer
local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")

-- True while cursors exist in this buffer.
--- @return boolean
local function session_active()
  return #vim.api.nvim_buf_get_extmarks(0, mc_ns, 0, -1, { limit = 1 }) > 0
end

-- Clear session state. `vim.b` reads copy; always reassign, never mutate.
local function reset_mc()
  vim.b.mc = nil
end

-- Literal `\V` pattern (`*`-like `\<..\>` when `is_word`).
--- @param text string
--- @param is_word boolean
--- @return string
local function to_pattern(text, is_word)
  local esc = vim.fn.escape(text, [[\]]):gsub("\n", "\\n")
  local prefix = FOLLOW_SMARTCASE and "\\V" or "\\V\\c"
  if is_word then
    return prefix .. "\\<" .. esc .. "\\>"
  end
  return prefix .. esc
end

--- Capture visual selection + start pos. Call before leaving visual.
--- @param vmode string live `mode()`
--- @return McSelection|nil sel or nil with reason
--- @return "blockwise"|"empty"|nil reason reason when `sel` is nil
local function visual_selection(vmode)
  -- Blockwise uses native `{Visual}Q`.
  if vmode == "\22" then
    return nil, "blockwise"
  end

  local vpos = vim.fn.getpos("v")
  local cpos = vim.fn.getpos(".")
  local region = vim.fn.getregion(vpos, cpos, { type = vmode })

  if type(region) ~= "table" or #region == 0 then
    return nil, "empty"
  end

  local text = table.concat(region, "\n")
  if text == "" then
    return nil, "empty"
  end

  local srow, scol = vpos[2], vpos[3]
  if cpos[2] < srow or (cpos[2] == srow and cpos[3] < scol) then
    srow, scol = cpos[2], cpos[3] -- earliest position
  end

  if vmode == "V" then
    scol = 1
  end

  return { text = text, srow = srow, scol = scol }
end

-- Normal mode: reuse pattern, restart on a new `<cword>`, start on `<cword>`.
--- @return string|nil pattern
local function ensure_pattern_from_normal()
  --- @type McState|nil
  local mc = vim.b.mc
  local pattern = type(mc) == "table" and mc.pattern or nil
  local word = vim.fn.expand("<cword>")
  local restart = type(pattern) ~= "string" or pattern == ""

  if not restart and mc ~= nil and word ~= "" and mc.word ~= nil and word ~= mc.word then
    -- Skip restart when the jump itself landed mid-word.
    local cur = vim.api.nvim_win_get_cursor(0)
    local landed = mc.landing
    local moved = type(landed) ~= "table" or landed[1] ~= cur[1] or landed[2] ~= cur[2]
    if moved then
      restart = true
      -- Restart on a new word (restorable via `gQ`).
      vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
    end
  end

  if restart then
    if word == "" then
      return nil
    end
    pattern = to_pattern(word, true)

    -- `searchpos()` moves the cursor; save it first.
    local orig = vim.api.nvim_win_get_cursor(0)
    local start = vim.fn.searchpos(pattern, "cbW")
    if start[1] == 0 then
      return nil -- word vanished (folds/race)
    end

    -- Keep intra-word column.
    local offset = 0
    if start[1] == orig[1] then
      offset = math.max(orig[2] - (start[2] - 1), 0)
    end

    -- Restore cursor.
    vim.api.nvim_win_set_cursor(0, orig)

    vim.b.mc = { word = word, pattern = pattern, offset = offset }
  end

  return pattern
end

-- Visual mode: selection always starts a fresh pattern.
--- @param vmode string live `mode()` passed through to `visual_selection`
--- @return string|nil pattern
local function ensure_pattern_from_visual(vmode)
  local sel, reason = visual_selection(vmode)
  if sel == nil then
    if reason == "blockwise" then
      reset_mc()
      vim.api.nvim_feedkeys("Q", "n", false) -- native per-line cursors
    end
    return nil
  end

  -- Selection captured; leave visual.
  vim.cmd.normal({ vim.keycode("<Esc>"), bang = true })

  -- Literal pattern, no word boundaries.
  local pattern = to_pattern(sel.text, false)

  -- Single-word selection tracks its word, so `<C-d>` on a different word restarts; Multi-word stays a free literal pattern.
  ---@type string|nil
  local word = sel.text
  if sel.text:find("%s") then
    word = nil
  end

  -- Fresh restart (restorable via `gQ`).
  vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)

  local line_len = #(vim.api.nvim_buf_get_lines(0, sel.srow - 1, sel.srow, true)[1] or "")
  local eoffset = 0
  local target

  if vmode == "V" then
    -- Linewise: anchor at line start.
    target = { sel.srow, math.min(math.max(sel.scol - 1, 0), line_len) }
  else
    -- Charwise: pin at selection end.
    local first = sel.text:match("([^\n]*)") or ""
    eoffset = math.max(#first - 1, 0)
    target = { sel.srow, math.min(sel.scol - 1 + eoffset, line_len) }
  end

  vim.api.nvim_win_set_cursor(0, target)
  vim.b.mc = { word = word, pattern = pattern, offset = eoffset }

  return pattern
end

-- Pin cursor here, jump primary to next match.
-- Jump with follow off (`2q=`), re-enable after (`1q=`).
--- @param pattern string explicit search pattern without modifying `@/` register
local function pin_and_jump(pattern)
  -- Follow off: the jump must not cascade.
  vim.cmd("normal! 2q=")

  -- Re-adding an existing cursor is a no-op.
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_mcursor(0, { cursor[1], cursor[2] })

  -- Leave a mark, like `]C`.
  vim.cmd("normal! m'")

  -- Next match; retry with `w` to wrap under `nowrapscan`.
  local found = vim.fn.search(pattern)
  if found == 0 then
    found = vim.fn.search(pattern, "w")
  end

  -- Restore intra-word column.
  if found ~= 0 then
    local mc0 = vim.b.mc
    local offset = type(mc0) == "table" and mc0.offset or nil
    if type(offset) == "number" and offset > 0 then
      local pos = vim.api.nvim_win_get_cursor(0)
      local matched_len = #(vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], true)[1] or "")
      vim.api.nvim_win_set_cursor(0, { pos[1], math.min(pos[2] + offset, matched_len) })
    end
  end

  -- Record landing (reassign: `vim.b` copies).
  local final = vim.api.nvim_win_get_cursor(0)

  --- @type McState|nil
  local mc = vim.b.mc
  if type(mc) == "table" then
    mc.landing = { final[1], final[2] }
    vim.b.mc = mc
  end

  -- Follow on for later motions/edits.
  vim.cmd("normal! 1q=")
end

-- `<C-d>`: fresh pattern from visual; reuse/restart from normal.
local function add_next_match()
  local mode = vim.fn.mode()
  local from_normal = mode == "n"
  local from_visual = mode == "v" or mode == "V" or mode == "\22"

  if not from_normal and not from_visual then
    return
  end

  if vim.api.nvim_mcursor == nil then
    return vim.notify("Multicursor needs Nvim with native multicursor (nvim_mcursor)", vim.log.levels.WARN)
  end

  -- Drop stale state with the session.
  if not session_active() then
    reset_mc()
  end

  local pattern
  if from_normal then
    pattern = ensure_pattern_from_normal()
  else
    pattern = ensure_pattern_from_visual(mode)
  end
  if pattern == nil then
    return
  end

  pin_and_jump(pattern)
end

-- init
vim.keymap.set({ "n", "x" }, "<C-d>", add_next_match, { silent = true, desc = "[MC] Add Next Match" })
