-- LaTeX specific keybindings

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>le",
	"<cmd>lua require('texlab_setup').LaTeXChangeEnv()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(0, "n", "<localleader>lc", "<cmd>TexlabBuild<CR>", { noremap = true, silent = true })

vim.api.nvim_buf_set_keymap(0, "n", "<localleader>ls", "<cmd>TexlabForward<CR>", { noremap = true, silent = true })
