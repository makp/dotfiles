-- Keymaps that don't require any plugins
-- See `:help function-list` for built-in functions

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

-- Use a easier keybinding for exiting terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--[[ -- Move to the beginning of the paragraph (a little hacky)
vim.api.nvim_set_keymap("n", "]_", "}j_", { noremap = true })
vim.api.nvim_set_keymap("n", "[_", "{{j_", { noremap = true }) ]]

--[[ -- Use j/k to move visual lines instead of actual lines
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true })
vim.api.nvim_set_keymap("n", "gj", "j", { noremap = true })
vim.api.nvim_set_keymap("n", "gk", "k", { noremap = true }) ]]

-- Buffers
vim.api.nvim_set_keymap("n", "]b", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[b", ":bprevious<CR>", { noremap = true, silent = true })

-- Create lines before and after the cursor
vim.api.nvim_set_keymap("n", "]<space>", "o<Esc>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "[<space>", "O<Esc>j", { noremap = true, silent = true })

-- Load helper functions
local hf = require("helper_funcs")

-- Open or switch to scratch file
function SwitchToScratch()
	local scratch_file = "~/OneDrive/computer_files/scratch_shared.md"
	hf.open_or_switch_to_file(scratch_file)
end
vim.api.nvim_set_keymap(
	"n",
	"<leader>os",
	"<cmd>lua SwitchToScratch()<CR>",
	{ noremap = true, silent = true, desc = "Open or switch to [s]cratch file" }
)

-- Check writing
function CheckWriting(mode)
	local py_cmd = "python"
	local buffer_txt = hf.get_text()
	-- print(buffer_txt)
	hf.run_cmd_async(py_cmd, {
		vim.fn.expand("~/.config/nvim/lua/utils/revise_prose.py"),
		buffer_txt,
		mode,
	})
end

vim.api.nvim_set_keymap(
	"v",
	"<leader>rw",
	"y <cmd>lua CheckWriting('academic')<CR>",
	{ noremap = true, silent = true, desc = "Check academic writing" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>rw",
	"<cmd>lua CheckWriting('academic')<CR>",
	{ noremap = true, silent = true, desc = "Check academic writing" }
)

-- Inspect code with GPT in a repl
local function inspect_code_with_gpt(model)
	-- Write code to a file
	local filepath = "/tmp/temp_code.md"
	hf.write_code_to_file(filepath)

	-- Split window
	vim.cmd("vsplit")

	-- Del past chat if it exists
	local chat_name = "code_chat"
	local chat_path = "/tmp/chat_cache/" .. chat_name
	if vim.fn.filereadable(chat_path) == 1 then
		vim.fn.delete(chat_path)
	end

	-- Run sgpt --repl in a terminal buffer
	local cmd = string.format("sgpt --model %s --repl %s < %s", model, chat_name, filepath)
	hf.run_cmd_in_term_buf(cmd)
end

function InspectCode()
	local model_basic = os.getenv("OPENAI_BASIC")
	local model_advanced = os.getenv("OPENAI_ADVANCED")
	local opts = { model_basic, model_advanced }
	hf.select_one_option(opts, function(choice)
		if choice then
			inspect_code_with_gpt(choice)
		else
			print("No model selected!")
		end
	end)
end

vim.api.nvim_set_keymap(
	"v",
	"<leader>ri",
	"y <cmd>lua InspectCode()<CR>",
	{ noremap = true, silent = true, desc = "[i]inspect code" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>ri",
	"<cmd>lua InspectCode()<CR>",
	{ noremap = true, silent = true, desc = "[i]inspect code" }
)
