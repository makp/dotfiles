-- HELPER FUNCS

function Run_cmd_async(cmd, cmd_args, callback)
	-- Optional arguments
	cmd_args = cmd_args or {}
	callback = callback or function(result)
		print(result)
	end

	-- Event loop
	local uv = vim.loop

	-- Create pipes
	local stdout = uv.new_pipe()
	local stderr = uv.new_pipe()

	-- Create process handle
	local handle

	-- Stored result to be processed by the callback
	local result = {}

	local options = {
		args = cmd_args,
		stdio = { nil, stdout, stderr }, -- input, output, error
	}

	local on_exit = function(_)
		-- Close and stop reading pipes
		uv.read_stop(stdout)
		uv.close(stdout)
		uv.read_stop(stderr)
		uv.close(stderr)

		-- Close the process
		uv.close(handle)

		-- Concatenate the result after the process is done
		local output = table.concat(result, "\n")
		callback(output)
	end

	local on_read = function(_, data)
		if data then
			-- print(data)
			table.insert(result, data)
		end
	end

	handle = uv.spawn(cmd, options, on_exit)

	-- Read from stdout
	uv.read_start(stdout, on_read)

	-- Read from stderr
	uv.read_start(stderr, on_read)
end

function Create_buffer(buffer_name, output)
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

-- Run a command and display the output in a new buffer
function RunCmdAsync(cmd, args)
	Run_cmd_async(cmd, args, function(result)
		vim.schedule(function()
			Create_buffer("*CmdOutput*", result)
		end)
	end)
end

function GetText()
	-- TODO: Write procedure for getting text from visual selection.
	-- local mode = vim.api.nvim_get_mode().mode
	-- local line1 = vim.fn.line("'<")
	-- local line2 = vim.fn.line("'>")
	-- local text = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
	-- selected_text = table.concat(text, "\n")

	-- Get text from the unnamed register
	local selected_text = vim.fn.getreg('"')
	-- Escape shell metacharacters
	return vim.fn.shellescape(selected_text)
end

function CheckWriting()
	local py_cmd = "python"
	local buffer_txt = GetText()
	-- print(buffer_txt)
	RunCmdAsync(py_cmd, {
		"/home/makmiller/.config/nvim/lua/utils/writing.py",
		buffer_txt,
	})
end

-- Keymaps
vim.api.nvim_set_keymap("v", "<leader>rs", "y <cmd>CheckWriting()", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>rs", CheckWriting()({ noremap = true, silent = true }))
