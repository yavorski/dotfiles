--- @brief Pure helpers shared by ui modules.

local M = {}

--- Flatten ui2 content chunks (`{{attr_id, text, hl_id}, ...}`) to a string.
--- @param content table|string|nil
--- @return string
function M.content_to_text(content)
  if content == nil then
    return ""
  end
  if type(content) ~= "table" then
    return tostring(content)
  end

  local parts = {}

  for _, chunk in ipairs(content) do
    if type(chunk) == "table" and chunk[2] then
      parts[#parts + 1] = chunk[2]
    end
  end

  return table.concat(parts)
end

--- @param win integer?
--- @return integer? win  non-nil only when the window is valid
function M.valid_win(win)
  if win == nil or win == -1 or not vim.api.nvim_win_is_valid(win) then
    return nil
  end
  return win
end

--- @class TitleEntry
--- @field [1] string  title text
--- @field [2] string  highlight group

--- Build the `title` chunk passed to `nvim_win_set_config`, with symmetric
--- padding so `title_pos = "center"` looks centered.
--- @param entry TitleEntry?
--- @return table?
function M.title_chunks(entry)
  if not entry then return nil end
  return { { " " .. vim.trim(entry[1]) .. " ", entry[2] } }
end

return M
