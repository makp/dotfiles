-- LaTeX specific config

-- Enable spell checking
vim.opt_local.spell = false

-- Keybindings
-- Change latex environment
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>te",
	"<cmd>lua require('texlab_setup').LaTeXChangeEnv()<CR>",
	{ noremap = true, silent = true }
)

-- Build PDF
vim.api.nvim_buf_set_keymap(0, "n", "<localleader>tb", "<cmd>TexlabBuild<CR>", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>tx",
	"<cmd>lua require('texlab_setup').LaTeXCancelBuild()<CR>",
	{ noremap = true, silent = true }
)

-- PDF forward search
vim.api.nvim_buf_set_keymap(0, "n", "<localleader>tp", "<cmd>TexlabForward<CR>", { noremap = true, silent = true })

-- Insert BibTeX references
vim.api.nvim_buf_set_keymap(0, "n", "<localleader>tb", "<cmd>Telescope bibtex<CR>", { noremap = true, silent = true })
