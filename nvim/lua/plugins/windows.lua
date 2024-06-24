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

	-- Integrate nvim window navigation with tmux
	{
		"christoomey/vim-tmux-navigator",
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
			vim.g.tmux_navigator_disable_when_zoomed = 1
		end,
		config = function()
			vim.keymap.set("n", "<A-h>", "<cmd>TmuxNavigateLeft<CR>")
			vim.keymap.set("n", "<A-j>", "<cmd>TmuxNavigateDown<CR>")
			vim.keymap.set("n", "<A-k>", "<cmd>TmuxNavigateUp<CR>")
			vim.keymap.set("n", "<A-l>", "<cmd>TmuxNavigateRight<CR>")
		end,
	},

	-- Open nvim windows in browser
	{
		"glacambre/firenvim",
		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
		lazy = not vim.g.started_by_firenvim,
		build = function()
			vim.fn["firenvim#install"](0)
		end,
	},
}
