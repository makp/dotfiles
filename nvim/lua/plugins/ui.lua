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

	-- Improved `vim.ui.input` (text input) and `vim.ui.select` (select one
	-- option)
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Misc UI improvements
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- Appearance
			animate = { enabled = true },
			input = { enabled = false }, -- `vim.ui.input` but not `vim.ui.select`
			statuscolumn = { enabled = true },
			scroll = { enabled = true },
			scope = { enabled = true },

			-- Notifications
			notifier = { enabled = true, timeout = 2000 }, -- `vim.notify`
			notify = { enabled = false }, -- utils for `vim.notify`

			-- Files
			quickfile = { enabled = true },
			bigfile = { enabled = true },

			-- Window mgmt
			bufdelete = { enabled = true }, -- `:bd` but keep layout
			layout = { enabled = false },
			win = { enabled = false },
			zen = { enabled = true },

			-- LSP-related
			rename = { enabled = true }, -- LSP-integrated rename
			words = { enabled = true }, -- LSP references

			-- Misc
			lazygit = { enabled = false },
			profiler = { enabled = false }, -- Neovim profiler
			scratch = { enabled = false },
			terminal = { enabled = false },
			toggle = { enabled = true }, -- toggle mappings
		},
		keys = {
			{
				"<C-w>z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Maximize window",
			},
			{
				"<C-w>Z",
				function()
					Snacks.zen()
				end,
				desc = "Zen mode",
			},
			{
				"<leader>ir",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "[r]ename file (LSP-aware)",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"]]",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Previous Reference",
				mode = { "n", "t" },
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "[d]elete buffer while keeping layout",
			},
			{
				"<leader>bD",
				function()
					Snacks.bufdelete.other()
				end,
				desc = "[D]elete other buffers while keeping layout",
			},

			{
				"<leader>ms",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "[s]how history",
			},

			{
				"<leader>md",
				function()
					Snacks.notifier.hide()
				end,
				desc = "[d]ismiss notifications",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Toggle mappings
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>tz")
					Snacks.toggle.diagnostics():map("<leader>td")
					Snacks.toggle.dim():map("<leader>tD")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>tc")
				end,
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
				{ "<leader>i", group = "f[i]le" },

				{ "<leader>b", group = "[b]uffer" },
				{ "<leader>d", group = "[d]ebug" },
				{ "<leader>t", group = "[t]oggle" },
				{ "<leader>m", group = "[m]essage" },

				-- localleader key chains
				{ "<localleader>a", group = "se[a]rch" },
				{ "<localleader>o", group = "c[o]de" },
				{ "<localleader>e", group = "r[e]view" },
				{ "<localleader>u", group = "j[u]mp" },
				{ "<localleader>i", group = "nav[i]gate" },

				{ "<localleader>h", group = "[h]unk" },
				{ "<localleader>d", group = "[d]iagnose" },
				{ "<localleader>s", group = "[s]end" },
			},
		},
	},
}
