local colors = require("colors/colors")

local statusline = { }

local function colorize(c, text)
  return {
    a = { bg = c, fg = colors.dark, gui = "bold" },
    b = { bg = colors.surface1, fg = colors.white, gui = "bold" },
    c = { bg = colors.dark, fg = text or c },
    x = { bg = colors.dark, fg = colors.text },
    y = { bg = colors.dark, fg = c }
  }
end

statusline.normal = colorize(colors.blue, colors.text)
statusline.insert = colorize(colors.green)
statusline.visual = colorize(colors.softcyan)
statusline.select = colorize(colors.yellow)
statusline.replace = colorize(colors.red)
statusline.command = colorize(colors.pink)
statusline.terminal = colorize(colors.softpink)

statusline.inactive = {
  a = { bg = colors.dark, fg = colors.skyblue, gui = "bold" },
  b = { bg = colors.dark, fg = colors.surface1, gui = "bold" },
  c = { bg = colors.dark, fg = colors.overlay0, gui = "bold" },
}

return statusline
