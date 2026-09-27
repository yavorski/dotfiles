--- @brief
--- Neovide skips shell rc files, so dirs are missing from PATH

local system = require("core/system")

if not vim.g.neovide then
  return
end

-- Same as bash/.path
local user_dirs = {
  "~/bin",
  "~/.npm/bin",
  "~/.local/bin",
  "~/.dotnet/tools",
}

-- Prepend in reverse to match list order
for i = #user_dirs, 1, -1 do
  local dir = vim.fn.expand(user_dirs[i])
  if vim.fn.isdirectory(dir) == 1 then
    local path = vim.env.PATH or ""
    if not (":" .. path .. ":"):find(":" .. dir .. ":", 1, true) then
      vim.env.PATH = dir .. ":" .. path
    end
  end
end

-- fzf-lua ripgrep
if not vim.env.RIPGREP_CONFIG_PATH then
  vim.env.RIPGREP_CONFIG_PATH = vim.fn.expand("$HOME/.ripgreprc")
end
