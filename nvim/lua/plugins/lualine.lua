local Lazy = require("core/lazy")
local colors = require("colors/colors")
local statusline_colors = require("colors/status-line")

-- show macro recording
local function show_macro()
  return vim.fn.reg_recording() == "" and "" or "Recording @" .. vim.fn.reg_recording()
end

-- copilot status
local function show_copilot()
  if not vim.g.loaded_copilot then return "★" end
  if not vim.g.copilot_enabled then return "" end
  return vim.b.copilot_enabled == false and "" or ""
end

-- tree-sitter status
local function show_tree_sitter()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.treesitter.highlighter.active[bufnr] ~= nil then
    return "󰐆"
  end
  return ""
end

-- lsp clients
local lsp_clients = ""
local function update_lsp_clients()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, vim.trim(client.name))
  end
  lsp_clients = table.concat(names, " | ")
end

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
  callback = function()
    vim.schedule(update_lsp_clients)
  end
})

local function show_lsp_clients()
  return lsp_clients
end

-- luaine statusline
Lazy.use {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  priority = 512,
  opts = {
    options = {
      theme = statusline_colors,
      globalstatus = true, -- will set `vim.opt.laststatus = 3`
      icons_enabled = true,
      section_separators = "", -- disable separators
      component_separators = "", -- disable separators
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 3 }, show_macro, "%S" },
      lualine_x = {
        "selectioncount",
        "searchcount",
        show_lsp_clients,
        show_copilot,
        show_tree_sitter,
        "encoding",
        "fileformat",
        "filesize",
        "filetype"
      },
      lualine_y = { "progress" },
      lualine_z = { "%2v:%l/%L" }
    },
    tabline = {
      lualine_a = {{
        "buffers",
        mode = 0, -- shows only buffer name
        icons_enabled = false,
        use_mode_colors = true,
        show_filename_only = true,
        show_modified_status = true,
        hide_filename_extension = false,
        max_length = vim.o.columns, -- maximum width of buffers component
        symbols = { modified = " ^", directory = "", alternate_file = "#" },
        filetype_names = { fzf = "FZF", lazy = "Lazy", noice = "Noice", trouble = "Trouble", NvimTree = "nvim-tree", checkhealth = "check-health" },
      }},
      lualine_y = { { function() return "[ Tab ]" end, color = { fg = colors.blue } } },
      lualine_z = { "tabs" }
    }
  },
  config = function(_, options)
    local H = require("lualine.highlight")
    local get_mode_suffix = H.get_mode_suffix

    H.get_mode_suffix = function() return
      vim.fn.mode() == "s" and "_select" or get_mode_suffix()
    end

    require("lualine").setup(options)
  end
}
