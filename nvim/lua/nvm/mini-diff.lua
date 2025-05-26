--- @brief
--- inline diff provider for codecompanion

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.diff",
  config = function()
    local MiniDiff = require("mini.diff")
    MiniDiff.config.view.priority = -1
    MiniDiff.config.delay.text_change = 10000
    MiniDiff.config.source = MiniDiff.gen_source.none()
    for key, _ in pairs(MiniDiff.config.mappings) do MiniDiff.config.mappings[key] = "" end
    for key, _ in pairs(MiniDiff.config.view.signs) do MiniDiff.config.view.signs[key] = "" end
    MiniDiff.setup()
  end
}
