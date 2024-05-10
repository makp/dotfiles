-- HELPER FUNCS

local function create_buffer(buffer_name, output)
	-- Split window and switch to it
	vim.api.nvim_command("vsplit")
	vim.api.nvim_command("wincmd l")
	-- Does buffer already exists?
	local buffer_exists = vim.fn.bufexists(buffer_name)
	if buffer_exists == 1 then
		-- Switch to it
		vim.api.nvim_command("buffer " .. buffer_name)
	else
		-- Create it
		vim.api.nvim_command("enew")
		-- Rename it
		vim.api.nvim_buf_set_name(0, buffer_name)
	end
	-- Clear previous content and insert new output
	vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
end

-- TODO: Create a separate function for getting text from visual selection.
-- local mode = vim.api.nvim_get_mode().mode
-- local line1 = vim.fn.line("'<")
-- local line2 = vim.fn.line("'>")
-- local text = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
-- selected_text = table.concat(text, "\n")

function RunScript(shell_cmd, bufname)
	-- Get text from the unnamed register
	local selected_text = vim.fn.getreg('"')
	-- Escape shell metacharacters
	local escaped_text = vim.fn.shellescape(selected_text)
	-- Construct the shell command
	local cmd = shell_cmd .. " " .. escaped_text
	-- Execute the command and capture the output
	local result = vim.fn.system(cmd)
	-- Create a new buffer with the output
	create_buffer(bufname, result)
end

vim.api.nvim_set_keymap(
	"v",
	"<leader>rs",
	"y <cmd>lua RunScript('python ~/.config/nvim/lua/utils/writing.py', '*ShellOutput*')<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>rs",
	"<cmd>lua RunScript('echo', '*ShellOutput*')<CR>",
	{ noremap = true, silent = true }
)
