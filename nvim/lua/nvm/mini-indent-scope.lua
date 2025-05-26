--- @brief
--- visualize and work with indent scope animated

local Lazy = require("core/lazy")

local function animate()
  return 0
end

Lazy.use {
  "nvim-mini/mini.indentscope",
  event = "VeryLazy",
  opts = {
    draw = {
      delay = 128,
      animation = animate
    },
    mappings = {
      goto_top = "",
      goto_bottom = "",
      object_scope = "",
      object_scope_with_border = "",
    },
    options = {
      n_lines = 128,
      try_as_border = false,
    }
  },
  init = function()
    vim.cmd[[autocmd FileType NvimTree lua vim.b.miniindentscope_disable = true]]
  end
}
