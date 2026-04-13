--- @brief
--- put, put_text, setup_auto_root, setup_restore_cursor, zoom

local Lazy = require("core/lazy")

local function setup()
  vim.defer_fn(function()
    _G.put = function(...)
      require("mini.misc").put(...)
    end

    _G.put_text = function(...)
      require("mini.misc").put_text(...)
    end
  end, 2048)
end

Lazy.use {
  src = "https://github.com/nvim-mini/mini.misc",
  data = {
    lazy = true,
    beforeAll = setup
  }
}
