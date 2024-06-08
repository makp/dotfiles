-- Enable spell checking
vim.opt_local.spell = false

-- Unfold first level headers at startup
vim.opt_local.foldlevel = 1

-- Set indentation
vim.bo.shiftwidth = 2 -- Num spaces with < and > cmds
vim.bo.tabstop = 2 -- <Tab> width
vim.bo.softtabstop = 2 -- Num spaces for each <Tab> press

-- Custom function for searching markdown headers
function MarkdownHeader()
	require("telescope.builtin").grep_string({
		prompt_title = "Markdown Headers",
		use_regex = true,
		search = "^#",
		search_dirs = { vim.fn.expand("%") },
	})
end

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<localleader>mh",
	"<cmd>lua MarkdownHeader()<CR>",
	{ noremap = true, silent = true }
)
