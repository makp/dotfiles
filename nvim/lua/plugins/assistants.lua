return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	config = function()
		require("chatgpt").setup({
			vim.api.nvim_set_keymap(
				"v",
				"<leader>ce",
				":ChatGPTRun explain_code<CR>",
				{ noremap = true, silent = true }
			),
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
