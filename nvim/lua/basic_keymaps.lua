--  See `:help vim.keymap.set()`

-- Map leader keys
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, { desc = "[s]how diagnostic messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "[q]uickfix list" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "previous [d]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next [d]iagnostic message" })

--[[ --  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
]]

-- Buffers
vim.api.nvim_set_keymap("n", "]b", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[b", ":bprevious<CR>", { noremap = true, silent = true })

-- Create lines before and after the cursor
vim.api.nvim_set_keymap("n", "]<space>", "o<Esc>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[<space>", "O<Esc>j", { noremap = true, silent = true })
