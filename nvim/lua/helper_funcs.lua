-- HELPER FUNCS

local function create_buffer(buffer_name, output)
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

function RunScript(shell_cmd, bufname)
	local mode = vim.api.nvim_get_mode().mode
	local selected_text

	-- FIXME: Visual mode is not being detected. Probably because the visual mode
	-- is no longer active when the function is called.
	if mode == "v" or mode == "V" then
		-- Get the selected text
		-- vim.api.nvim_command("normal! <Esc>")
		local line1 = vim.fn.line("'<")
		local line2 = vim.fn.line("'>")
		local text = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
		selected_text = table.concat(text, "\n")
		--
		-- vim.api.nvim_command("normal! gvy")
		-- selected_text = vim.fn.getreg("v")
		--
		-- local visual_text = vim.fn.getline("'<", "'>")
		-- selected_text = table.concat(visual_text, "\n")
	else
		-- Get the content of the unnamed register
		selected_text = vim.fn.getreg('"')
	end

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
	":<C-u>lua RunScript('echo', '*ShellOutput*')<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>rs",
	":<C-u>lua RunScript('echo', '*ShellOutput*')<CR>",
	{ noremap = true, silent = true }
)
