local Lazy = require("core/lazy")
-- show notifications
Lazy.use {
  "echasnovski/mini.notify",
  event = "VeryLazy",
  enabled = false,
  opts = {
    content = {
      format = function(notification)
        return notification.msg
      end,
    },
    window = {
      config = {
        border = "solid",
        row = 2,
        col = vim.o.columns - 2
      }
    }
  },
  config = function(_, options)
    require("mini.notify").setup(options)
    vim.notify = require("mini.notify").make_notify()
  end
}
