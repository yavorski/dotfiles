--- @brief Pure helpers shared by ui modules.

local M = {}

--- Chunks -> string.
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

--- Drop the trailing message terminator (`:!cmd` -> `":!cmd\r\n"`); inner newlines
--- kept, same table when unchanged.
--- @param content table
--- @return table
function M.trim_trailing_newline(content)
  if type(content) ~= "table" then
    return content
  end

  for i = #content, 1, -1 do
    local chunk = content[i]
    local text = type(chunk) == "table" and chunk[2]
    if type(text) == "string" and text ~= "" then
      local trimmed = text:gsub("[\r\n]+$", "")
      if trimmed == text then
        return content
      end
      -- Copy-on-write (global unpack: no table.unpack on LuaJIT).
      local out = { unpack(content) }
      if trimmed == "" and #out > 1 then
        table.remove(out, i)
      else
        out[i] = { chunk[1], trimmed, chunk[3] }
      end
      return out
    end
  end

  return content
end

--- @param win integer?
--- @return integer? win, nil unless valid
function M.valid_win(win)
  if win == nil or win == -1 or not vim.api.nvim_win_is_valid(win) then
    return nil
  end
  return win
end

--- @class TitleEntry
--- @field [1] string  title text
--- @field [2] string  highlight group

--- Padded title chunk for centered titles.
--- @param entry TitleEntry?
--- @return table?
function M.title_chunks(entry)
  if not entry then
    return nil
  end
  return { { " " .. vim.trim(entry[1]) .. " ", entry[2] } }
end

return M
