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

	-- Improve UI for messages, cmdline, and popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
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
	-- Run `checkhealth which-key` to see if there are any issues
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = { "echasnovski/mini.icons", version = false },
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps",
			},
		},
		opts = {
			spec = {
				-- Document existing key chains
				-- leader key chains
				{ "<leader>a", group = "p[a]ste" },
				{ "<leader>o", group = "[o]pen" },
				{ "<leader>e", group = "h[e]lp" },
				{ "<leader>u", group = "r[u]n" },
				-- { "<leader>i", group = "[i]nsert" },

				{ "<leader>f", group = "[f]ile" },
				{ "<leader>d", group = "[d]iagnose" },

				-- localleader key chains
				{ "<localleader>a", group = "se[a]rch" },
				{ "<localleader>o", group = "c[o]de" },
				{ "<localleader>e", group = "r[e]view" },
				{ "<localleader>u", group = "j[u]mp" },
				{ "<localleader>i", group = "nav[i]gate" },

				{ "<localleader>h", group = "[h]unk" },
				{ "<localleader>d", group = "[d]ebug" },
				{ "<localleader>s", group = "[s]end" },
			},
		},
	},
}
