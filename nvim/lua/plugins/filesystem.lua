return {
	-- Plain text file manager
	-- Type `g?` to see all keybindings
	-- See `:help oil-actions` for available cmds
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Initially toggle file details?
			local detail = false

			-- Define global function to display current dir
			function _G.get_oil_winbar()
				local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
				local dir = require("oil").get_current_dir(bufnr)
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					-- If there is no current directory (e.g. over ssh), just show the buffer name
					return vim.api.nvim_buf_get_name(0)
				end
			end

			-- Setup oil
			require("oil").setup({
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
					is_always_hidden = function(name, _)
						return name == ".." or name == ".git"
					end,
				},
				keymaps = {
					["<A-v>"] = {
						"actions.select",
						opts = { vertical = true },
						desc = "Open the entry in a vertical split",
					},
					["<A-s>"] = {
						"actions.select",
						opts = { horizontal = true },
						desc = "Open the entry in a horizontal split",
					},
					["~"] = false, -- it was tcd
					["`"] = false, -- it was cd
					["g."] = "actions.cd", -- it was toggle_hidden
					["<C-h>"] = "actions.toggle_hidden", -- it was hor split
					["<C-s>"] = "actions.change_sort", -- it was vert split
					["gd"] = {
						desc = "Toggle file detail view",
						callback = function()
							detail = not detail
							if detail then
								require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
				},
				win_options = {
					winbar = "%!v:lua.get_oil_winbar()",
					signcolumn = "yes:2", -- allow 2 sign columns for `oil-git-status.nvim`
				},
			})

			--
			vim.keymap.set("n", "<leader>o-", "<cmd>Oil<cr>", { desc = "parent directory" })
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>oh",
				"<cmd>Yazi<cr>",
				desc = "Open file manager at the current file",
			},
			{
				"<leader>ow",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in cwd",
			},
			{
				"<leader>or",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last file manager session",
			},
		},
	},
}
