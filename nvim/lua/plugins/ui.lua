return {
	-- Color scheme
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- Use termguicolors if available
			if vim.fn.has("termguicolors") == 1 then
				vim.opt.termguicolors = true
			end

			-- Use the dark theme
			vim.opt.background = "dark"

			-- Set foreground ('material', 'mix', 'original')
			vim.g.gruvbox_material_foreground = "material"

			-- Set background ('hard', 'medium', 'soft)
			vim.g.gruvbox_material_background = "soft"

			-- Enable bold in function names
			vim.g.gruvbox_material_enable_bold = 1

			-- Dim inactive windows
			vim.g.gruvbox_material_dim_inactive_windows = 1

			-- For better performance
			vim.g.gruvbox_material_better_performance = 1

			-- Load the colorscheme
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "gruvbox_dark" },
			})
		end,
	},

	-- Highlight TODOs in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Add indentation guides even on blank lines
	{
		"lukas-reineke/indent-blankline.nvim",
		-- version = "v3.5.4",
		-- See `:help ibl`
		config = function()
			require("ibl").setup()
		end,
		main = "ibl",
		opts = {},
	},

	-- Display pending keybindings
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			-- Decrease mapped sequence wait time
			-- Displays which-key popup sooner
			vim.opt.timeoutlen = 300

			require("which-key").setup()

			-- Document existing key chains
			require("which-key").register({
				-- leader key chains
				-- ["<leader>a"] = { name = "", _ = "which_key_ignore" },
				["<leader>e"] = { name = "gr[e]p", _ = "which_key_ignore" },
				["<leader>o"] = { name = "[o]pen", _ = "which_key_ignore" },
				-- ["<leader>u"] = { name = "", _ = "which_key_ignore" },
				["<leader>i"] = { name = "f[i]nd", _ = "which_key_ignore" },

				["<leader>g"] = { name = "[g]it", _ = "which_key_ignore" },
				["<leader>h"] = { name = "[h]elp for", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[d]iagnostics", _ = "which_key_ignore" },
				["<leader>O"] = { name = "[O]rgmode", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[r]un", _ = "which_key_ignore" },

				-- localleader key chains
				["<localleader>c"] = { name = "[c]ode", _ = "which_key_ignore" },
				["<localleader>r"] = { name = "[r]epl", _ = "which_key_ignore" },
				["<localleader>h"] = { name = "git [h]unk", _ = "which_key_ignore" },
			})
			-- visual mode
			-- require('which-key').register({
			-- 	['<leader>h'] = { 'Git [H]unk' },
			-- 	}, { mode = 'v' })
		end,
	},
}
