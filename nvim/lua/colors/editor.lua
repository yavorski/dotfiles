local mocha = require("colors/mocha")
local colors = require("colors/colors")

return {
  LineNr = { bg = colors.dusk },
  CursorLineNr = { bg = colors.darky },

  SignColumn = { bg = colors.dusk },
  SignColumnSB = { bg = colors.dusk },
  CursorLineSign = { bg = colors.darky },

  Folded = { bg = colors.surface0 },
  FoldColumn = { bg = colors.dusk },
  CursorLineFold = { fg = colors.red, bg = colors.darky },

  MsgArea = { bg = colors.darky},
  CursorLine = { bg = colors.matter },
  VertSplit = { fg = colors.darky, bg = colors.darky },
  WinSeparator = { fg = colors.darky, bg = colors.darky },

  NormalFloat = { bg = colors.base }, -- Floating windows
  FloatBorder = { fg = colors.blue, bg = colors.base }, -- Border for floating windows

  Visual = { bg = colors.surface0 },
  VisualNOS = { bg = colors.surface0 },

  Pmenu = { bg = colors.darky },
  PmenuSbar = { bg = colors.mantle },
  PmenuThumb = { bg = colors.teal },

  Search = { fg = colors.base, bg = mocha.yellow },
  IncSearch = { fg = colors.mantle, bg = mocha.red },
  CurSearch = { fg = colors.mantle, bg = mocha.red },

  YankHighlight = { fg = colors.base, bg = mocha.green },
  LspReferenceTarget = { }, -- <K> clear hover highlighting targeted word

  -- nvim mini
  MiniJump = { fg = colors.stealth, bg = colors.darkpink },
  MiniTrailspace = { bg = colors.red },
  MiniIndentscopeSymbol = { fg = colors.red },

  MiniNotifyNormal = { bg = colors.black },
  MiniNotifyBorder = { fg = colors.black, bg = colors.black },

  MiniMapNormal = { fg = colors.none, bg = colors.none },
  MiniMapSymbolLine = { fg = colors.pink, bg = colors.none },
  MiniMapSymbolView = { fg = colors.black, bg = colors.none },

  -- nvim marks -- not working
  -- MarkSignHL = { bg = colors.none },
  -- MarkSignNumHL = { fg = colors.none, bg = colors.none },

  -- nvim tree
  NvimTreeNormal = { bg = colors.base },
  NvimTreeCursorLine = { bg = colors.mantle },
  NvimTreeRootFolder = { fg = colors.peach },
  NvimTreeFolderName = { fg = colors.blue },
  NvimTreeFolderIcon = { fg = colors.skyblue },
  NvimTreeWinSeparator = { fg = colors.darky, bg = colors.darky },

  -- nvim gitsigns
  GitSignsAdd = { fg = colors.green, bg = colors.none },
  GitSignsChange = { fg = colors.yellow, bg = colors.none },
  GitSignsDelete = { fg = colors.red, bg = colors.none },

  -- noice
  NoiceDark = { bg = colors.mantle },

  -- which-key
  WhichKey = { bg = colors.crust },
  WhichKeyNormal = { bg = colors.crust },

  -- trouble
  TroubleNormal = { bg = colors.crust },
  TroubleNormalNC = { bg = colors.crust },
  TroublePos = { fg = colors.subtext1, bg = colors.none },
  TroubleCount = { fg = colors.green, bg = colors.none },

  -- blink
  BlinkCmpMenu = { bg = colors.base },
  BlinkCmpMenuBorder = { fg = colors.sapphire, bg = colors.base },
  BlinkCmpDoc = { bg = colors.base },
  BlinkCmpDocBorder = { fg = colors.sapphire, bg = colors.base },
  BlinkCmpScrollBarThumb = { bg = colors.maroon },

  -- copilot
  CopilotSuggestion = { style = { "italic" } },

  -- nvim fzf-lua
  FzfLuaTitle = { fg = colors.red, bg = colors.black },
  -- FzfLuaNormal = { fg = colors.text, bg = colors.mantle },
  -- FzfLuaBorder = { fg = colors.blue, bg = colors.mantle },
  FzfLuaCursorLine = { bg = colors.black },

  -- FzfLuaPreviewNormal = { bg = colors.crust },
  -- FzfLuaPreviewBorder = { fg = colors.crust, bg = colors.crust },
  FzfLuaPreviewTitle = { fg = colors.softcyan, bg = colors.black },

  -- FzfLuaFzfNormal = { bg = colors.mantle },
  FzfLuaFzfMatch = { fg = colors.blue },
  FzfLuaFzfSeparator = { fg = colors.black },
  FzfLuaFzfInfo = { fg = colors.flamingo },
  FzfLuaFzfPointer = { fg = colors.green },
  -- FzfLuaFzfBorder = { fg = colors.black },
  FzfLuaFzfScrollbar = { fg = colors.peach },
  FzfLuaFzfGutter = { link = "FzfLuaNormal" },
}
