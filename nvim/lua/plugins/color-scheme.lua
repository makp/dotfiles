return {
	"sainnhe/gruvbox-material",
	config = function()
		-- Use termguicolors if available
		if vim.fn.has("termguicolors") == 1 then
			vim.opt.termguicolors = true
		end

		-- Set background
		vim.opt.background = "dark"

		-- Set contrast
		vim.g.gruvbox_material_background = "medium"

		-- For better performance
		vim.g.gruvbox_material_better_performance = 1

		-- Load the colorscheme
		vim.cmd([[colorscheme gruvbox-material]])
	end,
}
