-- TEXLAB CONFIG

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>ce",
	"<cmd>lua require('texlab_setup').LaTeXChangeEnv()<CR>",
	{ noremap = true, silent = true }
)
