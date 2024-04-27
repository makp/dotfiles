-- Interactive REPLs
return {
	"Vigemus/iron.nvim",
	config = function()
		require("iron.core").setup({
			config = {
				-- Highlight the last sent block with bold
				highlight_last = "IronLastSent",
				-- Discard repl?
				scratch_repl = true,
				-- Close repl window on process end
				close_window_on_exit = true,
				-- repls
				repl_definition = {
					sh = {
						command = { "zsh" },
					},
					python = require("iron.fts.python").ipython,
				},
				--
				-- How repl window will be displayed
				--
				repl_open_cmd = require("iron.view").bottom(15),
				--
				-- Ignore blank lines when senting visual lines?
				ignore_blank_lines = true,
			},
			-- keymaps
			keymaps = {
				send_motion = "<localleader>sc",
				visual_send = "<localleader>sc",
				send_file = "<localleader>sf",
				send_line = "<localleader>sl",
				send_until_cursor = "<localleader>su",
				send_mark = "<localleader>sm",
				mark_motion = "<localleader>mc",
				mark_visual = "<localleader>mc",
				remove_mark = "<localleader>md",
				cr = "<localleader>s<cr>",
				interrupt = "<localleader>s<localleader>",
				exit = "<localleader>sq",
				clear = "<localleader>cl",
			},
			-- Highlight (check nvim_set_hl)
			highlight = {
				italic = true,
			},
		})

		-- See :h iron-commands for all available commands
		vim.keymap.set("n", "<localleader>rs", "<cmd>IronRepl<cr>")
		vim.keymap.set("n", "<localleader>rr", "<cmd>IronRestart<cr>")
		vim.keymap.set("n", "<localleader>rf", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<localleader>rh", "<cmd>IronHide<cr>")
	end,
}
