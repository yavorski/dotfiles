local colors = require("colors/colors")

return {
  -- nvim
  Include = { fg = colors.pink },
  Constant = { fg = colors.peach },
  Exception = { fg = colors.red },
  Repeat = { fg = colors.maroon },

  -- Type = { fg = colors.stealth },
  -- Structure = { fg = colors.peach },
  -- StorageClass = { fg = colors.yellow },

  -- lsp
  ["@lsp.type.comment"] = { link = "@lsp" }, -- disable lsp comments, use tree-sitter instead

  -- tree-sitter
  ["@constant"] = { fg = colors.peach },
  ["@constant.builtin"] = { fg = colors.pink },
  ["@exception"] = { fg = colors.red },
  ["@keyword.return"] = { fg = colors.red },
  ["@keyword.export"] = { fg = colors.pink },
  ["@keyword.operator"] = { fg = colors.stealth },
  ["@keyword.coroutine"] = { fg = colors.stealth },

  -- rust
  ["@lsp.typemod.keyword.async.rust"] = { fg = colors.stealth },
  ["@lsp.typemod.keyword.await.rust"] = { fg = colors.stealth },

  -- dotnet tree-sitter
  ["@type.c_sharp"] = { fg = colors.trick },
  ["@type.qualifier.c_sharp"] = { link = "@keyword" },
  ["@keyword.modifier.c_sharp"] = { fg = colors.mauve },
  ["@keyword.operator.c_sharp"] = { fg = colors.yellow },
  ["@keyword.coroutine.c_sharp"] = { fg = colors.yellow },

  -- dotnet lsp semantic tokens
  ["@lsp.type.class.cs"] = { link = "@lsp" }, -- disable styling attributes as classes
  ["@lsp.type.keyword.cs"] = { link = "@lsp" }, -- disable "keyword" since everything is a "keyword" and uses only 1 color
  ["@lsp.type.struct.cs"] = { fg = colors.peach },
  ["@lsp.type.enum.cs"] = { fg = colors.flamingo },
  ["@lsp.type.interface.cs"] = { fg = colors.rosewater },
  -- ["@lsp.typemod.class.static.cs"] = { fg = colors.softcyan },
  -- ["@lsp.type.namespace.cs"] = { fg = colors.peach, style = { "italic" } },

  -- css
  ["cssPseudo"] = { fg = colors.mauve },
  ["cssBoxProp"] = { link = "@property" },
  ["cssFontProp"] = { link = "@property" },
  ["cssTextProp"] = { link = "@property" },
  ["cssColorProp"] = { link = "@property" },
  ["cssVisualProp"] = { link = "@property" },
  ["cssBorderProp"] = { link = "@property" },
  ["cssAdvancedProp"] = { link = "@property" },
  ["cssBackgroundProp"] = { link = "@property" },

  -- stylus
  ["stylusId"] = { fg = colors.pink },
  ["stylusClass"] = { fg = colors.red },
  ["stylusImport"] = { fg = colors.pink },
  ["stylusVariable"] = { fg = colors.green },
  ["stylusProperty"] = { link = "@property" },

  -- xml
  ["xmlAttrib"] = { fg = colors.peach }
}
