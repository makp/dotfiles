-- HELPER FUNCS

-- Create table to store functions
local H = {}

-- Event loop
-- See `help: luv` for more info on the `vim.loop` module. It is essentially a
-- wrapper around libuv. For examples of Neovim processes using luv, see:
-- https://teukka.tech/luvbook/
local uv = vim.loop

-- Run a cmd asynchronously and call a callback with the result
local function run_cmd_async(cmd, cmd_args, callback)
	-- Optional arguments
	cmd_args = cmd_args or {}
	callback = callback or function(result)
		print(result)
	end

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

-- Create a buffer and display the output
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
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = buffer_id })
		vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buffer_id })
		vim.api.nvim_set_option_value("swapfile", false, { buf = buffer_id })
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

local function is_visual_mode()
	local mode = vim.api.nvim_get_mode().mode
	return mode == "v" or mode == "V"
end

local function get_visual_selection()
	-- Switch to normal mode
	-- Neovim apparently doesn't update the visual selection when the function is called.
	vim.cmd("normal! <Esc>")

	-- Get the visual selection
	local line1 = vim.fn.line("'<")
	local line2 = vim.fn.line("'>")
	local text = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
	return table.concat(text, "\n")
end

-- Get text
function H.get_text()
	local selected_text
	if is_visual_mode() then
		selected_text = get_visual_selection()
	else
		-- Get text from the unnamed register
		selected_text = vim.fn.getreg('"')
	end

	-- Escape shell metacharacters
	return vim.fn.shellescape(selected_text)
end

-- Write text to a file as a markdown code block
local function write_text_as_codeblock(filepath, text)
	-- Expand `filepath` to its full path
	filepath = vim.fn.expand(filepath)

	-- Get the filetype of the current buffer
	local filetype = vim.bo.filetype

	-- Open file for writing
	local file = io.open(filepath, "w")

	-- Write to `filepath` and close it
	if file then
		-- text = text:gsub("^'(.*)'$", "%1")
		file:write("```" .. filetype .. "\n" .. text .. "\n```")
		file:close()
	else
		print("Error: Could not open file for writing")
	end
end

-- Run a cmd asynchronously and display the output in a new buffer
function H.run_cmd_async_and_display_buf(cmd, args)
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

-- Open or switch to a file
function H.open_or_switch_to_file(filepath)
	-- Expand `filepath` to its full path
	filepath = vim.fn.expand(filepath)
	local current_buf = vim.api.nvim_get_current_buf()
	local current_name = vim.api.nvim_buf_get_name(current_buf)

	-- If the current win is visiting `filepath`, close it
	if current_name == filepath then
		vim.cmd("close")
		return
	end

	-- Look for a window displaying `filepath`
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		if name == filepath then
			-- Switch to the window displaying filepath
			vim.api.nvim_set_current_win(win)
			return
		end
	end

	-- If `filepath` is not found, open it in a new window
	vim.cmd("vsplit " .. filepath)
end

function H.write_code_to_file(filepath)
	local buffer_txt = H.get_text()
	write_text_as_codeblock(filepath, buffer_txt)
end

function H.run_cmd_in_term_buf(cmd)
	-- Check if `cmd` is valid
	if type(cmd) ~= "string" or cmd == "" then
		print("Error: Invalid command")
		return
	end

	-- Create a terminal buffer and run the cmd in it
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(buf)
	vim.fn.termopen(cmd)

	-- Set buffer opts
	vim.bo.buftype = "terminal"
	vim.bo.swapfile = false

	-- Start insert mode
	vim.cmd("startinsert")
end

local function is_dir(path)
	local stat = uv.fs_stat(path)
	return stat and stat.type == "directory"
end

function H.del_dir(path)
	if is_dir(path) then
		uv.fs_rmdir(path)
	else
		print("Error: Path is not a directory")
	end
end

function H.select_one_option(menu_opts, callback)
	vim.ui.select(menu_opts, {
		prompt = "Select an option:",
	}, function(choice)
		if choice then
			callback(choice)
		else
			print("No option selected!")
			callback(nil)
		end
	end)
end

-- Return the table
return H
