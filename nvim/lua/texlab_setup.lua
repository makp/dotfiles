-- TEXLAB SETUP

-- Define helper function for running TexLab cmds
local function texlab_command(cmd, params)
	vim.lsp.buf.execute_command({
		command = cmd,
		arguments = { params } or {},
	})
end

local dic = {}

-- TODO: I manually added the envs. There should be a way to get them from the
-- server.
dic.environments = {
	"equation",
	"equation*",
	"table",
	"tabular",
	"tabular*",
	"itemize",
	"enumerate",
	"description",
	"figure",
	"figure*",
	"center",
}

-- Wrapper func on `texlab.changeEnvironment` command
local function texlab_change_env(new_env)
	if new_env == nil then
		print("No environment name provided")
	else
		-- Get current positions pars
		local params = vim.lsp.util.make_position_params()
		-- Add the new name to the params
		params["newName"] = new_env
		-- Execute the command
		texlab_command("texlab.changeEnvironment", params)
	end
end

-- Use vim.ui.select to select an environment
function dic.LaTeXChangeEnv()
	vim.ui.select(dic.environments, {
		prompt = "Select an environment: ",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if choice then
			texlab_change_env(choice)
		else
			print("No environment selected!")
		end
	end)
end

-- Wrapper func on `texlab.cancelBuild` command
function dic.LaTeXCancelBuild()
	texlab_command("texlab.cancelBuild")
end

return dic
