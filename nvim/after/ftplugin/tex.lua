-- TEXLAB CONFIG

-- Define helper function for running TexLab cmds
local function texlab_command(cmd, params)
	vim.lsp.buf.execute_command({
		command = cmd,
		arguments = { params } or {},
	})
end

-- Change the current latex environment
function LaTeX_change_env()
	-- Prompt user for the new environment name
	local newName = vim.fn.input("New environment name: ")
	if newName == nil then
		print("No environment name provided")
	else
		-- Get current positions pars
		local params = vim.lsp.util.make_position_params()
		-- Add the new name to the params
		params["newName"] = newName
		-- Execute the command
		texlab_command("texlab.changeEnvironment", params)
	end
end

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>ce",
	"<cmd>lua LaTeX_change_env()<CR>",
	{ noremap = true, silent = true }
)
