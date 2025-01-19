-- Enable spell checking
vim.opt_local.spell = false

-- Unfold first level headers at startup
vim.opt_local.foldlevel = 2

-- C-x/C-a toggles
local existing_toggles = vim.b.CtrlXA_Toggles or vim.g.CtrlXA_Toggles or {}
vim.b.CtrlXA_Toggles = vim.list_extend({
	{ "#", "##", "###", "####", "#####", "######" },
}, existing_toggles)

-- Open REPL for Python
vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>oR",
	"<cmd>vsplit term://ipython --InteractiveShell.autoindent=False<CR><C-w>h",
	{ desc = "open REPL for Python" }
)
