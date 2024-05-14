-- LaTeX specific keybindings

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>te",
	"<cmd>lua require('texlab_setup').LaTeXChangeEnv()<CR>",
	{ noremap = true, silent = true }
)

vim.api.nvim_buf_set_keymap(0, "n", "<localleader>tc", "<cmd>TexlabBuild<CR>", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "<localleader>ts", "<cmd>TexlabForward<CR>", { noremap = true, silent = true })
