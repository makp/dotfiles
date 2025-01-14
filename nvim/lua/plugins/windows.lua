return {
	-- Add func for toggling window maximization
	{
		"declancm/maximize.nvim",
		keys = {
			{
				"<C-w>z",
				function()
					require("maximize").toggle()
				end,
				desc = "Toggle maximize window",
			},
		},
	},

	-- Edit text areas in web browsers with Neovim
	-- {
	-- 	"glacambre/firenvim",
	-- 	build = ":call firenvim#install(0)",
	-- },
	{
		"subnut/nvim-ghost.nvim",
		keys = {
			{ "<leader>lw", desc = "Enable sync with [w]eb browser." },
		},
		config = function()
			vim.api.nvim_create_autocmd("User", {
				group = "nvim_ghost_user_autocommands",
				pattern = "*.com",
				callback = function()
					vim.bo.filetype = "markdown"
				end,
			})
		end,
	},
}
