-- Keymaps and functions that don't depend on any external plugin
-- See `:help function-list` for built-in functions

-- Map leader keys
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

-- Quickfix keymaps
vim.keymap.set("n", "<leader>oq", "<cmd>copen<CR>", { desc = "open [q]uickfix window" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Go to the *next* item quickfix list" })
vim.keymap.set("n", "]Q", "<cmd>clast<CR>", { desc = "Go to the *last* item quickfix list" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Go to the *previous* item quickfix list" })
vim.keymap.set("n", "[Q", "<cmd>cfirst<CR>", { desc = "Go to the *first* item quickfix list" })

-- Diagnostic keymaps
vim.keymap.set("n", "<localleader>ds", vim.diagnostic.open_float, { desc = "[s]how diagnostic messages" })
vim.keymap.set("n", "<localleader>dq", vim.diagnostic.setloclist, { desc = "diagnostic [q]uickfix list" })

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

-- Use Alt to navigate between windows
vim.keymap.set({ "n", "v" }, "<A-h>", "<C-w>h", { noremap = true })
vim.keymap.set({ "n", "v" }, "<A-j>", "<C-w>j", { noremap = true })
vim.keymap.set({ "n", "v" }, "<A-k>", "<C-w>k", { noremap = true })
vim.keymap.set({ "n", "v" }, "<A-l>", "<C-w>l", { noremap = true })
vim.keymap.set({ "n", "v" }, "<A-n>", "<C-w>w", { noremap = true })

-- Load helper functions
local hf = require("helper_funcs")

-- Open external terminal in current buffer's directory
function OpenTerminal()
	local cmd = "alacritty"
	local dir = vim.fn.expand("%:p:h")
	dir = string.gsub(dir, "oil://", "") -- Remove "oil://" prefix if present
	vim.fn.jobstart(cmd .. " --working-directory " .. dir)
end
vim.keymap.set("n", "<leader>ot", "<cmd>lua OpenTerminal()<CR>", { desc = "open [t]erminal" })

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
	local py_cmd = "assistant_revise-prose.py"
	hf.run_cmd_async_and_display_buf(py_cmd, {
		buffer_txt,
		style,
	})
end

function ProofreadProse()
	local buffer_txt = hf.get_text()
	local opts = { "academic_anthropic", "academic", "prose", "email" }
	hf.select_one_option(opts, function(choice)
		if choice then
			proofread(choice, buffer_txt)
		else
			print("No style selected!")
		end
	end)
end

vim.keymap.set({ "n", "v" }, "<leader>up", function()
	ProofreadProse()
end, { desc = "Check prose writing" })

-- Inspect code with GPT in a repl
--[[ local function inspect_code_with_gpt(model, filepath)
	-- Del past sgpt chat if it exists
	local chat_name = "code_chat"
	local chat_path = "/tmp/chat_cache/" .. chat_name
	if vim.fn.filereadable(chat_path) == 1 then
		vim.fn.delete(chat_path)
	end

	-- Run sgpt --repl in a terminal buffer
	local cmd = string.format("sgpt --model %s --temperature 1 --repl %s < %s", model, chat_name, filepath)
	hf.run_cmd_in_tmux_pane(cmd)
end ]]

--[[ function InspectCode()
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
end ]]

--[[ vim.keymap.set({ "n", "v" }, "<leader>ui", function()
	InspectCode()
end, { desc = "Inspect code" }) ]]

-- Run code assistant
local function run_code_assistant(mode, buffer_txt)
	local py_cmd = "assistant_coding.py"
	local lang = vim.bo.filetype
	hf.run_cmd_async_and_display_buf(py_cmd, {
		buffer_txt,
		lang,
		mode,
	})
end

function RunCodeAssistant()
	local buffer_txt = hf.get_text()
	local opts = { "explain", "optimize", "explain_light", "optimize_light" }
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
	local py_cmd = "assistant_coding.py"
	hf.run_cmd_async_and_display_floating_win(py_cmd, { buffer_txt, filetype, "explain_light" })
end

vim.keymap.set({ "n", "v" }, "<localleader>oA", function()
	RunCodeAssistant()
end, { desc = "Code [A]ssistant" })

vim.keymap.set({ "n", "v" }, "<localleader>oe", function()
	code_explain_light()
end, { desc = "Code [e]xplain light" })

-- Copy file path to clipboard
function CopyPathToClipboard()
	-- See :help filename-modifiers
	local opts = { "absolute path", "absolute dir", "filename", "relative path", "relative dir" }
	local function copy_to_clipboard(text)
		-- Remove "oil://" prefix if present
		-- note: the relative paths don't work in oil
		text = string.gsub(text, "oil://", "")
		vim.fn.setreg("+", text)
		print("Copied to clipboard: " .. text)
	end
	hf.select_one_option(opts, function(choice)
		if choice == "absolute path" then
			copy_to_clipboard(vim.fn.expand("%:p"))
		elseif choice == "absolute dir" then
			copy_to_clipboard(vim.fn.expand("%:p:h"))
		elseif choice == "filename" then
			copy_to_clipboard(vim.fn.expand("%:t"))
		elseif choice == "relative path" then
			copy_to_clipboard(vim.fn.expand("%:p:."))
		elseif choice == "relative dir" then
			copy_to_clipboard(vim.fn.expand("%:p:.:h")) -- %:h
		else
			print("No action selected!")
		end
	end)
end

vim.keymap.set("n", "<leader>iy", function()
	CopyPathToClipboard()
end, { desc = "Copy file info" })
