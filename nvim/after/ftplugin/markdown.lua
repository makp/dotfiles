-- Enable spell checking
vim.opt_local.spell = true

-- Custom function for markdown headers
function MarkdownHeader()
	require("telescope.builtin").grep_string({
		prompt_title = "Markdown Headers",
		use_regex = true,
		search = "^#",
		search_dirs = { vim.fn.expand("%") },
	})
end

vim.keymap.set("n", "<localleader>mh", "<cmd>lua MarkdownHeader()<CR>", { noremap = true, silent = true })
