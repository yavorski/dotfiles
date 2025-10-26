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

-- buffer navigation require nvim-lualine/lualine.nvim plugin
vim.keymap.set("n", "gb$", "<cmd>LualineBuffersJump $<cr>", { silent = true })
vim.keymap.set("n", "gb1", "<cmd>LualineBuffersJump! 1<cr>", { silent = true })
vim.keymap.set("n", "gb2", "<cmd>LualineBuffersJump! 2<cr>", { silent = true })
vim.keymap.set("n", "gb3", "<cmd>LualineBuffersJump! 3<cr>", { silent = true })
vim.keymap.set("n", "gb4", "<cmd>LualineBuffersJump! 4<cr>", { silent = true })
vim.keymap.set("n", "gb5", "<cmd>LualineBuffersJump! 5<cr>", { silent = true })
vim.keymap.set("n", "gb6", "<cmd>LualineBuffersJump! 6<cr>", { silent = true })
vim.keymap.set("n", "gb7", "<cmd>LualineBuffersJump! 7<cr>", { silent = true })
vim.keymap.set("n", "gb8", "<cmd>LualineBuffersJump! 8<cr>", { silent = true })
vim.keymap.set("n", "gb9", "<cmd>LualineBuffersJump! 9<cr>", { silent = true })
vim.keymap.set("n", "gb0", "<cmd>LualineBuffersJump! 10<cr>", { silent = true })

-- command mode - prev and next command from history
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Prev command in history" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Next command in history" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>N", function() vim.wo.relativenumber = not vim.wo.relativenumber end, { desc = "Toggle Relative Numbers" })
