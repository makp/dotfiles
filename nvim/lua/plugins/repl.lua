-- Interactive REPLs
return {
	"jpalardy/vim-slime",
	init = function()
		vim.g.slime_no_mappings = 1
		vim.g.slime_python_ipython = 1 -- Use %cpaste with IPython to avoid indentation errors
	end,
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_default_config = {
			socket_name = "default",
			target_pane = "{right-of}",
		}
		vim.keymap.set("n", "<localleader>sc", "<Plug>SlimeParagraphSend")
		vim.keymap.set("v", "<localleader>sc", "<Plug>SlimeRegionSend")
		vim.keymap.set("n", "<localleader>sl", "<Plug>SlimeLineSend")
		vim.keymap.set("n", "<localleader>ss", function()
			local key1 = vim.api.nvim_replace_termcodes("<Plug>SlimeParagraphSend", true, false, true)
			local key2 = vim.api.nvim_replace_termcodes(
				"<cmd>lua require('helper_funcs').move_to_next_code_line() <CR>",
				true,
				false,
				true
			)
			vim.api.nvim_feedkeys(key1, "n", true)
			vim.api.nvim_feedkeys("}", "n", true)
			vim.api.nvim_feedkeys(key2, "n", true)
		end)
	end,
}
