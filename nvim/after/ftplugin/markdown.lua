-- Enable spell checking
vim.opt_local.spell = true

vim.g.markdown_indent_level = 2 -- Default is 4

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
