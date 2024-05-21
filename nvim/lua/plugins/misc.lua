return {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Comment
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Autopair
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- Automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
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
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
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
				view_options = { show_hidden = true },
			})
			vim.keymap.set("n", "<leader>o-", "<cmd>Oil<cr>", { desc = "parent directory" })
		end,
	},
	-- It appears that `oil.nvim` overwrites the `gx` mapping. Using the
	-- following plugin restores it.
	{
		"chrishrb/gx.nvim",
		keys = {
			{ "gx", "<cmd>Browse<cr>", mode = { "n", "x" } },
		},
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, -- default settings
		submodules = false, -- not needed, submodules are required only for tests
	},

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
