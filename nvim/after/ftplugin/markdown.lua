-- Enable spell checking
vim.opt_local.spell = true

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

-- Custom keybindings for running code (`SnipRun`)
vim.api.nvim_buf_set_keymap(0, "v", "<localleader>sc", "<Plug>SnipRun", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "<localleader>sl", "<Plug>SnipRun", { silent = true })
vim.api.nvim_buf_set_keymap(0, "n", "<localleader>sc", "<Plug>SnipRunOperator", { silent = true })
