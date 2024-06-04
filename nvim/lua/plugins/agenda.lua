return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			-- Setup orgmode
			require("orgmode").setup({
				org_agenda_files = "~/elisp/agendas/**/*",
				-- org_default_notes_file = '~/orgfiles/refile.org',
				mappings = { prefix = "<leader>O" },
			})
		end,
	},
}
