-- Keymaps and functions that don't depend on any external plugin
-- See `:help function-list` for built-in functions

-- Map leader keys
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, { desc = "[s]how diagnostic messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "[q]uickfix list" })

-- Use a easier keybinding for exiting terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffers
vim.keymap.set("n", "]b", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[b", ":bprevious<CR>", { noremap = true, silent = true })

-- Create lines before and after the cursor
vim.keymap.set("n", "]<space>", "o<Esc>k", { noremap = true, silent = true })
vim.keymap.set("n", "[<space>", "O<Esc>j", { noremap = true, silent = true })

--[[ -- Use j/k to move visual lines instead of actual lines
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "gj", "j", { noremap = true })
vim.keymap.set("n", "gk", "k", { noremap = true }) ]]

-- Load helper functions
local hf = require("helper_funcs")

-- Open or switch to scratch file
function SwitchToScratch()
	local scratch_file = "~/OneDrive/computer_files/scratch_shared.md"
	hf.open_or_switch_to_file(scratch_file)
end
vim.keymap.set(
	"n",
	"<leader>os",
	"<cmd>lua SwitchToScratch()<CR>",
	{ noremap = true, silent = true, desc = "open or switch to [s]cratch file" }
)

-- Proofread text
local function proofread(style, buffer_txt)
	local py_cmd = "revise_prose.py"
	hf.run_cmd_async_and_display_buf(py_cmd, {
		buffer_txt,
		style,
	})
end

function ProofreadProse()
	local buffer_txt = hf.get_text()
	local opts = { "academic", "prose", "email" }
	hf.select_one_option(opts, function(choice)
		if choice then
			proofread(choice, buffer_txt)
		else
			print("No style selected!")
		end
	end)
end

vim.keymap.set({ "n", "v" }, "<leader>rp", function()
	ProofreadProse()
end, { desc = "Check prose writing" })

-- Inspect code with GPT in a repl
local function inspect_code_with_gpt(model, filepath)
	-- Del past sgpt chat if it exists
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
	-- Write code to a file
	local filepath = "/tmp/temp_code.md"
	hf.write_code_to_file(filepath)

	local model_basic = os.getenv("OPENAI_BASIC")
	local model_advanced = os.getenv("OPENAI_ADVANCED")
	local opts = { model_basic, model_advanced }
	hf.select_one_option(opts, function(choice)
		if choice then
			vim.cmd("vsplit")
			inspect_code_with_gpt(choice, filepath)
		else
			print("No model selected!")
		end
	end)
end

vim.keymap.set({ "n", "v" }, "<leader>ri", function()
	InspectCode()
end, { desc = "Inspect code" })
