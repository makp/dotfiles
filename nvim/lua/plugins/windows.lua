return {
	-- Add func for toggling window maximization
	{
		"declancm/maximize.nvim",
		config = function()
			vim.keymap.set("n", "<C-w>z", function()
				require("maximize").toggle()
			end, { desc = "Toggle maximize window" })
		end,
	},

	-- Open nvim windows in browser
	{
		"glacambre/firenvim",
		build = ":call firenvim#install(0)",
	},
}
