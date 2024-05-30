return {
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
					["gv"] = "open_vsplit", -- not the best keymap
					["gs"] = "open_split",
				},
			},
			filesystem = {
				follow_current_file = { enabled = true },
			},
		})
		vim.keymap.set("n", "<leader>ob", ":Neotree buffers<CR>", { desc = "Open [b]uffers using neotree" })
		vim.keymap.set("n", "<leader>of", ":Neotree reveal toggle<CR>", { desc = "Toggle [f]ilesystem with neotree" })

		vim.keymap.set(
			"n",
			"<leader>gt",
			":Neotree reveal git_status toggle<CR>",
			{ desc = "Toggle git status with neo[t]ree" }
		)
	end,
}
