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
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "]B", "<cmd>bfirst<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[B", "<cmd>blast<CR>", { noremap = true, silent = true })

-- Create lines before and after the cursor
vim.keymap.set("n", "]<space>", "o<Esc>k", { noremap = true, silent = true })
vim.keymap.set("n", "[<space>", "O<Esc>j", { noremap = true, silent = true })

-- Use j/k to move visual lines instead of actual lines
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "gj", "j", { noremap = true })
vim.keymap.set("n", "gk", "k", { noremap = true })

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
	local cmd = string.format("sgpt --model %s --temperature 1 --repl %s < %s", model, chat_name, filepath)
	hf.run_cmd_in_tmux_pane(cmd)
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
			-- vim.cmd("vsplit")
			inspect_code_with_gpt(choice, filepath)
		else
			print("No model selected!")
		end
	end)
end

vim.keymap.set({ "n", "v" }, "<leader>ri", function()
	InspectCode()
end, { desc = "Inspect code" })

-- Run code assistant
local function run_code_assistant(mode, buffer_txt)
	local py_cmd = "code_assistant.py"
	local lang = vim.bo.filetype
	hf.run_cmd_async_and_display_buf(py_cmd, {
		buffer_txt,
		lang,
		mode,
	})
end

function RunCodeAssistant()
	local buffer_txt = hf.get_text()
	local opts = { "explain", "optimize", "explain_light", "optmize_light" }
	hf.select_one_option(opts, function(choice)
		if choice then
			run_code_assistant(choice, buffer_txt)
		else
			print("No action selected!")
		end
	end)
end

local function code_explain_light()
	local buffer_txt = hf.get_text()
	local filetype = vim.bo.filetype
	local py_cmd = "code_assistant.py"
	hf.run_cmd_async_and_display_floating_win(py_cmd, { buffer_txt, filetype, "explain_light" })
end

vim.keymap.set({ "n", "v" }, "<localleader>cA", function()
	RunCodeAssistant()
end, { desc = "Code [A]ssistant" })

vim.keymap.set({ "n", "v" }, "<localleader>ce", function()
	code_explain_light()
end, { desc = "Code [e]xplain light" })

function CopyPathToClipboard()
	-- See :help filename-modifiers
	local opts = { "fullpath", "filename", "dirname", "relative" }
	local function copy_to_clipboard(text)
		-- Remove "oil://" prefix if present
		text = string.gsub(text, "oil://", "")
		vim.fn.setreg("+", text)
		print("Copied to clipboard: " .. text)
	end
	hf.select_one_option(opts, function(choice)
		if choice == "fullpath" then
			copy_to_clipboard(vim.fn.expand("%"))
		elseif choice == "filename" then
			copy_to_clipboard(vim.fn.expand("%:t"))
		elseif choice == "dirname" then
			copy_to_clipboard(vim.fn.expand("%:h"))
		elseif choice == "relative" then
			copy_to_clipboard(vim.fn.expand("%:p:."))
		else
			print("No action selected!")
		end
	end)
end

vim.keymap.set("n", "<leader>f", function()
	CopyPathToClipboard()
end, { desc = "Copy file info" })
