--- @brief
--- Sublime-like - `<C-d>` - Add cursor and jump to next match.
--- Wraps to the first match instead of stopping; cycling is intentional.
--- Uses explicit patterns + `nvim_mcursor()`, so `@/`, `hlsearch`, history and `n`/`N` are untouched.

-- Native multicursor extmark namespace.
local mc_ns = vim.api.nvim_create_namespace("nvim.multicursor")

-- True when a native multicursor session is active in this buffer.
local function session_active()
  return #vim.api.nvim_buf_get_extmarks(0, mc_ns, 0, -1, { limit = 1 }) > 0
end

-- Literal whole-word pattern (`*`-like). Only `\` needs escaping under `\V`.
local function whole_word_pattern(word)
  -- follow ignorecase/smartcase
  return "\\V\\<" .. vim.fn.escape(word, [[\]]) .. "\\>"

  -- ignore casing
  -- return "\\V\\c\\<" .. vim.fn.escape(word, [[\]]) .. "\\>"
end

-- Literal pattern for arbitrary selections. Embedded newlines become `\n`.
local function literal_pattern(text)
  local esc = vim.fn.escape(text, [[\]])
  esc = esc:gsub("\n", "\\n")

  -- follow ignorecase/smartcase
  return "\\V" .. esc

  -- ignore casing
  -- return "\\V\\c" .. esc
end

--- Current visual selection + start pos, without yanking.
--- Call while visual is still active; `vmode` is the live `mode()`. Caller exits visual after.
--- @param vmode string live `mode()` value (`v`, `V` or blockwise `<C-v>`)
--- @return string|nil selected text, `nil` when there is no usable selection
--- @return integer|string|nil srow start row (1-indexed) on success, blockwise/empty reason on failure
--- @return integer|nil scol start col (1-indexed byte col) on success
local function visual_selection(vmode)
  -- blockwise: delegates to native {Visual}Q
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

  local srow, scol, erow, ecol = vpos[2], vpos[3], cpos[2], cpos[3]
  if erow < srow or (erow == srow and ecol < scol) then
    srow, scol = erow, ecol -- earliest position
  end

  if vmode == "V" then
    scol = 1
  end

  return text, srow, scol
end

-- Pin current match and jump to next.
-- From visual starts a fresh pattern.
-- From normal reuses it, restarts on a different `<cword>`, or starts from `<cword>`.
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

  -- Stale pattern dies with the session (covers `<C-L>` clear).
  if not session_active() then
    vim.b.mc_word = nil
    vim.b.mc_offset = nil
    vim.b.mc_pattern = nil
  end

  -- active mc search pattern
  local pattern = vim.b.mc_pattern

  if from_normal then
    local word = vim.fn.expand("<cword>")
    local restart = type(pattern) ~= "string" or pattern == ""

    if not restart and word ~= "" and vim.b.mc_word ~= nil and word ~= vim.b.mc_word then
      restart = true
      -- New word: clean restart; wiped session stays restorable via `gQ`.
      vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
    end

    if restart then
      if word == "" then return end
      pattern = whole_word_pattern(word)

      -- NB: searchpos() moves the cursor as a side effect; capture orig first.
      local orig = vim.api.nvim_win_get_cursor(0)
      local start = vim.fn.searchpos(pattern, "cbW") -- word start, for column offset
      if start[1] == 0 then
        return -- word vanished (folds/race)
      end

      -- Stay where initiated; remember intra-word column for later jumps.
      local offset = 0
      if start[1] == orig[1] then
        offset = math.max(orig[2] - (start[2] - 1), 0)
      end

      -- undo searchpos() cursor move
      vim.api.nvim_win_set_cursor(0, orig)

      vim.b.mc_word = word
      vim.b.mc_offset = offset
      vim.b.mc_pattern = pattern
    end
  end

  if from_visual then
    local text, srow, scol = visual_selection(mode)
    if text == nil or type(srow) ~= "number" or type(scol) ~= "number" then
      if srow == "blockwise" then
        vim.b.mc_word = nil
        vim.b.mc_offset = nil
        vim.b.mc_pattern = nil
        vim.api.nvim_feedkeys("Q", "n", false) -- native per-line cursors
      end
      -- empty: stay in visual, nothing to do
      return
    end

    vim.cmd.normal({ vim.keycode("<Esc>"), bang = true })
    pattern = literal_pattern(text) -- fresh selection restarts the pattern
    vim.b.mc_pattern = pattern

    -- Single-word selection tracks its word, so normal-mode `<C-d>` on a different word restarts;
    -- Multi-word stays a free literal pattern.
    if text:find("%s") then
      vim.b.mc_word = nil
    else
      vim.b.mc_word = text
    end

    if srow < 1 or srow > vim.api.nvim_buf_line_count(0) then
      return -- stale visual position
    end

    -- Clean restart; wiped session stays restorable via `gQ`.
    vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
    if mode == "V" then
      -- Linewise: anchor at line start.
      vim.b.mc_offset = 0
      local lines = vim.api.nvim_buf_get_lines(0, srow - 1, srow, true)
      local line_len = #(lines[1] or "")
      vim.api.nvim_win_set_cursor(0, { srow, math.min(math.max(scol - 1, 0), line_len) })
    else
      -- Charwise: pin at selection end; jumps stay end-relative.
      -- Direction-independent: forward and backward selections of the same text produce the same cursors.
      local first = text:match("([^\n]*)") or ""
      local eoffset = math.max(#first - 1, 0)
      local lines = vim.api.nvim_buf_get_lines(0, srow - 1, srow, true)
      local line_len = #(lines[1] or "")
      vim.api.nvim_win_set_cursor(0, { srow, math.min(scol - 1 + eoffset, line_len) })
      vim.b.mc_offset = eoffset
      -- pin lands at selection end
    end
  end

  -- Re-adding an existing cursor is a no-op.
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_mcursor(0, { cursor[1], cursor[2] })

  -- Leave a mark, like `]C`.
  vim.cmd("normal! m'")

  -- Next match via `pattern`; leaves `@/` untouched.
  local found = vim.fn.search(pattern)

  -- Keep all cursors at the initiator's intra-word column.
  -- Runs for both modes: visual initiation stores its offset above,
  -- normal initiation (or reuse) stores it in the `from_normal` branch.
  if found ~= 0 then
    local offset = vim.b.mc_offset
    if type(offset) == "number" and offset > 0 then
      local pos = vim.api.nvim_win_get_cursor(0)
      local matched = vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], true)
      local matched_len = #(matched[1] or "")
      vim.api.nvim_win_set_cursor(0, { pos[1], math.min(pos[2] + offset, matched_len) })
    end
  end
end

-- init
vim.keymap.set({ "n", "x" }, "<C-d>", add_next_match, { silent = true, desc = "[MC] Add Next Match" })
vim.keymap.set({ "n", "x" }, "<A-d>", add_next_match, { silent = true, desc = "[MC] Add Next Match" })
