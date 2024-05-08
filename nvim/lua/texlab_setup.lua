local dic = {}

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
}

-- Define helper function for running TexLab cmds
local function texlab_command(cmd, params)
	vim.lsp.buf.execute_command({
		command = cmd,
		arguments = { params } or {},
	})
end

-- Wrapper func on `texlab.changeEnvironment` command
-- In `dic.TexlabChangeEnv`, `TexlabChangeEnv` is the key and the function itself is the value
function dic.TexlabChangeEnv(new_env)
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
			dic.TexlabChangeEnv(choice)
		else
			print("No environment selected!")
		end
	end)
end

return dic
