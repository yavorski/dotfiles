local Lazy = require("core/lazy")

-- rust.vim
Lazy.use { "rust-lang/rust.vim", ft = "rust" }

-- LSP Rust will setup rust-analyzer
Lazy.use {
  "mrcjkb/rustaceanvim",
  ft = "rust",
  version = "*",
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          relative = "cursor",
        }
      },
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            procMacro = { enable = true },
            inlayHints = {
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              }
            }
          }
        },
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>C", function() vim.cmd.RustLsp("flyCheck") end, { silent = true, buffer = bufnr, desc = "LSP Run Clippy" })
          vim.keymap.set("n", "<leader>E", function() vim.cmd.RustLsp("explainError") end, { silent = true, buffer = bufnr, desc = "LSP Explain Error" })
        end
      },
    }
  end
}
