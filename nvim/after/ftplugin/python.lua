vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>cR",
	"<cmd>80vsplit term://ipython<CR>",
	{ desc = "open REPL for Python" }
)

--[[ -- C-x/C-a toggles for Python
local existing_toggles = vim.b.CtrlXA_Toggles or vim.g.CtrlXA_Toggles or {}
vim.b.CtrlXA_Toggles = vim.list_extend({
	{ "print", "feio", "nada", "naosei" },
}, existing_toggles) ]]
