--- @brief
--- put, put_text, setup_auto_root, setup_restore_cursor, zoom

local Lazy = require("core/lazy")

Lazy.use {
  "nvim-mini/mini.misc",
  opts = { },
  init = function()
    _G.put = function(...)
      require("mini.misc").put(...)
    end

    _G.put_text = function(...)
      require("mini.misc").put_text(...)
    end
  end
}
