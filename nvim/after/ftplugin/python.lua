vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>oR",
	"<cmd>vsplit term://ipython<CR><C-w>h",
	{ desc = "open REPL for Python" }
)

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>sz",
	"<cmd>lua require('helper_funcs').center_terminal_window()<CR>",
	{ desc = "Center terminal window" }
)
