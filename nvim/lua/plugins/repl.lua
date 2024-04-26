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
				send_motion = "<space>sc",
				visual_send = "<space>sc",
				send_file = "<space>sf",
				send_line = "<space>sl",
				send_until_cursor = "<space>su",
				send_mark = "<space>sm",
				mark_motion = "<space>mc",
				mark_visual = "<space>mc",
				remove_mark = "<space>md",
				cr = "<space>s<cr>",
				interrupt = "<space>s<space>",
				exit = "<space>sq",
				clear = "<space>cl",
			},
			-- Highlight (check nvim_set_hl)
			highlight = {
				italic = true,
			},
		})

		-- See :h iron-commands for all available commands
		vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
		vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
	end,
}
