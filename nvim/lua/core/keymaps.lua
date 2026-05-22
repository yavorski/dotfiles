------------------------------------------------------------
-- Leader
------------------------------------------------------------

-- Space <Leader>
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[ ]]

-- Default <Leader>
-- vim.g.mapleader = [[\]]
-- vim.g.maplocalleader = [[\]]

------------------------------------------------------------
-- Keymaps
------------------------------------------------------------

-- Map <F1> to Escape
vim.cmd("map <F1> <esc>")
vim.cmd("map! <F1> <esc>")

-- Disable built in |m| key - marks operations
vim.keymap.set({ "n", "v", "x" }, "m", "<Nop>", { silent = true })

-- Disable built in |s| key - deletes char under cursor
-- vim.keymap.set({ "n", "v", "x" }, "s", "<Nop>", { silent = true })

-- Save file/buffer
vim.keymap.set("n", "<Leader>w", "<cmd>write<CR>", { desc = "Write File" })

-- Match brackets remap
-- vim.keymap.set({ "n", "v", "x" }, "mm", "%", { silent = true })
vim.keymap.set("n", "mm", "<Plug>(MatchitNormalForward)", { silent = true })
vim.keymap.set({ "v", "x" }, "mm", "<Plug>(MatchitVisualForward)", { silent = true })

-- comment - additional keymaps
vim.api.nvim_set_keymap("v", "<C-c>", "gc", { silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", "gcc", { silent = true })

-- Remap x X
vim.keymap.set({ "n", "v", "x" }, "X", "x", { silent = true, desc = "Delete char" })
vim.keymap.set({ "n", "v", "x" }, "x", [["_x]], { silent = true, desc = "Delete without yank" })

-- copy/paste system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { silent = true, desc = "[sc] Yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>Y", [["+yy]], { silent = true, desc = "[sc] Yank Line" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", [["+p]], { silent = true, desc = "[sc] Paste After" })
vim.keymap.set({ "n", "v", "x" }, "<leader>P", [["+P]], { silent = true, desc = "[sc] Paste Before" })
vim.keymap.set({ "v", "x" }, "<leader>d", [["+d]], { silent = true, desc = "[sc] Yank Delete" })
vim.keymap.set({ "n" }, "<leader>%y", "<cmd>silent! %y+<cr>", { silent = true, desc = "[sc] Yank Buffer" })

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
vim.keymap.set("n", "[p", [[<Cmd>exe "put! " . v:register<CR>]], { silent = true, desc = "Paste Above" })
vim.keymap.set("n", "]p", [[<Cmd>exe "put "  . v:register<CR>]], { silent = true, desc = "Paste Below" })

-- buffer navigation prev/next ]b and [b is default
vim.keymap.set("n", "gp", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "gn", "<cmd>bnext<cr>", { silent = true })

-- command mode - prev and next command from history
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Prev command in history" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Next command in history" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>N", function() vim.wo.relativenumber = not vim.wo.relativenumber end, { desc = "Toggle Relative Numbers" })

-- buffer navigation by tabline index
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("local/tabline-jump", { clear = true }),
  once = true,
  callback = function()
    local function tabline_jump(n)
      local listed = {}
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[b].buflisted then table.insert(listed, b) end
      end
      if #listed == 0 then return end
      local idx = (n == "$") and #listed or tonumber(n)
      if not idx or idx < 1 or idx > #listed then return end
      vim.api.nvim_set_current_buf(listed[idx])
    end

    -- jump 1,9
    for i = 1, 9 do
      vim.keymap.set("n", "gb" .. i, function() tabline_jump(i) end, { silent = true, desc = "Buffer " .. i  })
    end

    -- jump to last
    vim.keymap.set("n", "gb$", function() tabline_jump("$") end, { silent = true, desc = "Buffer Last" })
    vim.keymap.set("n", "gb0", function() tabline_jump("$") end, { silent = true, desc = "Buffer Last" })
  end
})
