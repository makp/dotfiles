return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						["<C-c>"] = "close_window",
						["<A-v>"] = "open_vsplit", -- not the best keymap
						["<A-s>"] = "open_split",
					},
				},
				filesystem = {
					hijack_netrw_behavior = "disabled",
					follow_current_file = { enabled = true },
				},
			})
			vim.keymap.set("n", "<leader>tb", ":Neotree buffers toggle<CR>", { desc = "Open [b]uffers using neotree" })
			vim.keymap.set("n", "<leader>tf", ":Neotree toggle<CR>", { desc = "Toggle [f]ilesystem with neotree" })

			vim.keymap.set(
				"n",
				"<leader>tg",
				":Neotree git_status toggle<CR>",
				{ desc = "Toggle git status with neo[t]ree" }
			)
		end,
	},

	-- Plain text file manager
	-- Type `g?` to see all keybindings
	-- See `:help oil-actions` for available cmds
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
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
				},
			})
			vim.keymap.set("n", "<leader>o-", "<cmd>Oil<cr>", { desc = "parent directory" })
		end,
	},

	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>odh",
				"<cmd>Yazi<cr>",
				desc = "Open file manager at the current file",
			},
			{
				"<leader>odw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's cwd",
			},
			{
				"<leader>odr",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
	},

	{ "akinsho/toggleterm.nvim", version = "*", config = true },
}
