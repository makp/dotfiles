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

	-- Open nvim windows in browser
	{
		"glacambre/firenvim",
		build = ":call firenvim#install(0)",
	},
}
