-- Interactive REPLs
return {
	"jpalardy/vim-slime",
	init = function()
		vim.g.slime_no_mappings = 1
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
			local keys = vim.api.nvim_replace_termcodes("<Plug>SlimeParagraphSend", true, false, true)
			vim.api.nvim_feedkeys(keys, "n", true)
			require("helper_funcs").move_to_next_code_line()
		end)
	end,
}
