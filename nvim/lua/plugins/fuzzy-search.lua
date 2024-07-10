return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzflua = require("fzf-lua")

			fzflua.setup({
				keymap = {
					builtin = {
						["<F1>"] = "toggle-help",
						["<F2>"] = "toggle-fullscreen",
						-- Only valid with the 'builtin' previewer
						["<F3>"] = "toggle-preview-wrap",
						["<F4>"] = "toggle-preview",
						-- Rotate preview clockwise/counter-clockwise
						["<F5>"] = "toggle-preview-ccw",
						["<F6>"] = "toggle-preview-cw",
						["<A-w>"] = "toggle-preview-wrap",
						-- Scroll preview window
						["<C-d>"] = "preview-page-down",
						["<C-u>"] = "preview-page-up",
						-- ["<S-left>"] = "preview-page-reset",
					},
				},
			})

			-- Find
			vim.keymap.set("n", "<leader>if", fzflua.files, { desc = "[f]iles in cwd" })
			vim.keymap.set("n", "<leader>ib", fzflua.buffers, { desc = "[b]uffers" })
			vim.keymap.set("n", "<leader>ir", fzflua.oldfiles, { desc = "[r]ecent files" })

			-- Grep
			vim.keymap.set("n", "<leader>eb", fzflua.lgrep_curbuf, { desc = "current [b]uffer" })
			vim.keymap.set("n", "<leader>ef", fzflua.live_grep, { desc = "[f]iles in cwd" })
			vim.keymap.set("n", "<leader>ew", fzflua.grep_cword, { desc = "files containing [w]ord" })
			vim.keymap.set("n", "<leader>eW", fzflua.grep_cWORD, { desc = "files containing [W]ORD" })
		end,
	},
	{
		-- Type C-/ (insert mode) or ? (normal mode) for listing all the keymaps
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				-- Enable fzf algorithm for Telescope
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated. This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			{ "nvim-telescope/telescope-bibtex.nvim" },
		},
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		config = function()
			local bibtex_actions = require("telescope-bibtex.actions")

			require("telescope").setup({
				-- defaults = {},
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					bibtex = {
						global_files = { "/home/makmiller/Documents/mydocs/tex-configs/references/evol.bib" },
						mappings = {
							i = {
								["<CR>"] = bibtex_actions.key_append([[\citet{%s}]]),
								["<C-b>"] = bibtex_actions.key_append([[\citep{%s}]]),
							},
						},
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "bibtex")

			-- Keymaps
			local builtin = require("telescope.builtin")

			-- Help keymaps
			vim.keymap.set("n", "<leader>ht", builtin.help_tags, { desc = "[t]ags" })
			vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "[k]eymaps" })
			vim.keymap.set("n", "<leader>hm", builtin.man_pages, { desc = "[m]an pages" })

			-- Telescope
			vim.keymap.set("n", "<leader>rt", builtin.builtin, { desc = "[t]elescope" })
			vim.keymap.set("n", "<leader>rr", builtin.resume, { desc = "[r]esume" })

			-- Find
			vim.keymap.set("n", "<leader>in", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[n]eovim files" })

			-- Grep
			vim.keymap.set("n", "<leader>en", builtin.treesitter, { desc = "treesitter [n]odes" })

			-- Git
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[s]tatus" })
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "[c]ommits" })

			-- Registers
			vim.keymap.set("n", "<leader>or", builtin.registers, { desc = "[r]egisters" })

			-- Jumps
			vim.keymap.set("n", "<leader>oj", builtin.jumplist, { desc = "[j]umplist" })

			-- Diagnostics
			vim.keymap.set("n", "<leader>dj", builtin.diagnostics, { desc = "[j]ump" })

			-- Spell
			vim.keymap.set("n", "z=", builtin.spell_suggest, { desc = "spell [c]heck" })
		end,
	},
}
