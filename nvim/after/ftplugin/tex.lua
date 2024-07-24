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

-- Folding
-- FIXME: `zj` is working properly but `zk` is not. This suggests that there
-- might be an issue with how the fold boundaries are being set.
vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { scope = "local" })
vim.api.nvim_set_option_value("foldlevel", 99, { scope = "local" })
