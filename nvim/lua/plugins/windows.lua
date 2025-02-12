return {
	-- Edit text areas in web browsers with Neovim
	-- {
	-- 	"glacambre/firenvim",
	-- 	build = ":call firenvim#install(0)",
	-- },
	{
		-- NOTE: Setting `nvim_ghost_autostart` to zero in the init produces an
		-- error when setting the autcmd. Setting the `keys` property for some
		-- reason causes the server not to load. Similarly, the server doesn't load
		-- properly when `lazy=true`.
		"subnut/nvim-ghost.nvim",
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
