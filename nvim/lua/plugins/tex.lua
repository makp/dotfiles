return {
	"lervag/vimtex",
	lazy = false, -- don't lazy load VimTeX
	init = function()
		vim.cmd("filetype plugin indent on")
		vim.cmd("syntax enable")
		vim.g.vimtex_view_method = "zathura"
	end,
}
