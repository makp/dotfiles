-- HELPER FUNCS
-- See `help: luv` for more info on the `vim.loop` module. It is essentially a
-- wrapper around libuv. For examples of Neovim processes using luv, see:
-- https://teukka.tech/luvbook/

local function run_cmd_async(cmd, cmd_args, callback)
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

	-- Store results to be processed by the callback
	local result = {}

	-- Spawn process
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

	handle = uv.spawn(cmd, options, on_exit)

	-- Read from stdout and stderr
	local on_read = function(_, data)
		if data then
			-- print(data)
			table.insert(result, data)
		end
	end

	uv.read_start(stdout, on_read)
	uv.read_start(stderr, on_read)
end

local function create_buffer(buffer_name, output)
	-- Does `buffer_name` already exist? 0 = no, 1 = yes.
	local buffer_exists = vim.fn.bufexists(buffer_name)

	local buffer_id, wid_id

	-- Create `buffer_name` if it doesn't exist
	if buffer_exists == 0 then
		-- Split window and switch to it
		vim.api.nvim_command("vsplit")
		vim.api.nvim_command("wincmd l")

		vim.api.nvim_command("enew")
		buffer_id = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_name(buffer_id, buffer_name)

		-- Avoid save prompts
		vim.api.nvim_buf_set_option(buffer_id, "buftype", "nofile")
		vim.api.nvim_buf_set_option(buffer_id, "bufhidden", "hide")
		vim.api.nvim_buf_set_option(buffer_id, "swapfile", false)
	else
		-- Get buffer and window IDs
		buffer_id = vim.fn.bufnr(buffer_name)
		wid_id = vim.fn.bufwinnr(buffer_id)

		-- Is it visible? If buffer is not displayed, `wid_id` will be -1.
		if wid_id ~= -1 then
			-- Switch to it
			vim.api.nvim_command(wid_id .. "wincmd w")
		else
			-- Split window and switch to it
			vim.api.nvim_command("vsplit")
			vim.api.nvim_command("wincmd l")
			vim.api.nvim_command("buffer " .. buffer_name)
		end
	end

	-- Clear previous content and insert new output
	vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, {})
	vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, vim.split(output, "\n"))
end

-- Run a command and display the output in a new buffer
function RunCmdAsync(cmd, args)
	run_cmd_async(cmd, args, function(result)
		-- Vim cmds cannot be called within a lua loop callback. So, we need to
		-- schedule them. See also `:help vim.schedule_wrap()` for when you need to a
		-- wrap a function that needs to be scheduled multiple times with different
		-- arguments.
		vim.schedule(function()
			create_buffer("*CmdOutput*", result)
		end)
	end)
end

local function get_text()
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
	local buffer_txt = get_text()
	-- print(buffer_txt)
	RunCmdAsync(py_cmd, {
		"/home/makmiller/.config/nvim/lua/utils/writing.py",
		buffer_txt,
	})
end

-- Keymaps
vim.api.nvim_set_keymap("v", "<leader>rs", "y <cmd>lua CheckWriting()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>rs", "<cmd>lua CheckWriting()<CR>", { noremap = true, silent = true })
