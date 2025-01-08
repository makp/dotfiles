vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>cR",
	"<cmd>80vsplit term://ipython<CR>",
	{ desc = "open REPL for Python" }
)
