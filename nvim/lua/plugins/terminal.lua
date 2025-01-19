return {
	-- Neovim repl
	{
		"ii14/neorepl.nvim",
		cmd = "Repl",
	},
	{
		-- Interactive REPLs
		"jpalardy/vim-slime",
		init = function()
			vim.g.slime_target = "neovim"
			vim.g.slime_no_mappings = 1
			-- vim.g.slime_python_ipython = 1 -- Use %cpaste with IPython to avoid indentation errors
			vim.g.slime_bracketed_paste = 1
		end,
		config = function()
			vim.g.slime_suggest_default = 1
			vim.g.slime_input_pid = 0
			vim.g.slime_menu_config = 1
			vim.g.slime_neovim_ignore_unlisted = 0

			vim.keymap.set("n", "<localleader>s", "<Plug>SlimeMotionSend", { desc = "Send motion" })
			vim.keymap.set("x", "<localleader>s", "<Plug>SlimeRegionSend", { desc = "Send selection" })
			vim.keymap.set("n", "<localleader>ss", "<Plug>SlimeLineSend", { desc = "Send line" })
			vim.keymap.set("n", "<localleader>sp", "<Plug>SlimeParagraphSend", { desc = "Send paragraph" })
			vim.keymap.set("n", "<localleader>sP", function()
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
			end, { desc = "Send paragraph and move to next code block" })
		end,
	},
}
