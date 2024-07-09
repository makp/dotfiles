return {
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
		vim.keymap.set("n", "<leader>if", builtin.find_files, { desc = "[f]iles in cwd" })
		vim.keymap.set("n", "<leader>ib", builtin.buffers, { desc = "[b]uffers" })
		vim.keymap.set("n", "<leader>ir", builtin.oldfiles, { desc = "[r]ecent files" })
		vim.keymap.set("n", "<leader>in", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[n]eovim files" })

		-- Grep
		vim.keymap.set("n", "<leader>ef", builtin.live_grep, { desc = "[f]iles in cwd" })
		vim.keymap.set("n", "<leader>ew", builtin.grep_string, { desc = "files containing [w]ord" })
		vim.keymap.set("n", "<leader>eF", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "restrict to open [F]iles" })
		vim.keymap.set("n", "<leader>eb", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "current [b]uffer" })
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
}
