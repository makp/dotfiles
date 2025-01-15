vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>cR",
	"<cmd>vsplit term://ipython --InteractiveShell.autoindent=False<CR><C-w>h",
	{ desc = "open REPL for Python" }
)

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>sz",
	"<cmd>wincmd l<CR>G<cmd>normal! zz<CR><C-w>h",
	{ desc = "Center terminal window" }
)
