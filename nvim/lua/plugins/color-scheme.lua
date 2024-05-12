return {
	"sainnhe/gruvbox-material",
	config = function()
		-- Use termguicolors if available
		if vim.fn.has("termguicolors") == 1 then
			vim.opt.termguicolors = true
		end

		-- Use the dark theme
		vim.opt.background = "dark"

		-- Set foreground ('material', 'mix', 'original')
		vim.g.gruvbox_material_foreground = "material"

		-- Set background ('hard', 'medium', 'soft)
		vim.g.gruvbox_material_background = "soft"

		-- Enable bold in function names
		vim.g.gruvbox_material_enable_bold = 1

		-- FIXME: Not working
		-- Dim inactive windows
		vim.g.gruvbox_material_dim_inactive_windows = 1

		-- For better performance
		vim.g.gruvbox_material_better_performance = 1

		-- Load the colorscheme
		vim.cmd([[colorscheme gruvbox-material]])
	end,
}
