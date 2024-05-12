-- Use `<leader>s` for within document searches, and `<leader>f` for multiple files

return {
	-- Typing C-/ (insert mode) or ? (normal mode) lists all the keymaps
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	-- [[ Configure Telescope ]]
	-- See `:help telescope` and `:help telescope.setup()`
	config = function()
		require("telescope").setup({
			-- Default mappings / updates / etc.
			-- Info: `:help telescope.setup()`
			--
			defaults = {
				mappings = {
					i = { ["<c-enter>"] = "to_fuzzy_refine" },
				},
			},
			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		-- Help keymaps
		vim.keymap.set("n", "<leader>ht", builtin.help_tags, { desc = "[H]elp [T]ags" })
		vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "[H]elp [K]eymaps" })
		vim.keymap.set("n", "<leader>hm", builtin.man_pages, { desc = "[H]elp [M]an Pages" })

		-- Telescope search
		vim.keymap.set("n", "<leader>ft", builtin.builtin, { desc = "[F]ind [T]elescope Search" })
		vim.keymap.set("n", "<leader><leader>", builtin.resume, { desc = "[S]earch [R]esume" })

		-- Multiple flles
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
		vim.keymap.set("n", "<leader>fF", builtin.buffers, { desc = "Find existing buffers" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>fG", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch with Grep in Open Files" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [R]ecent Files" })

		-- Git
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "[O]pen [G]it [S]tatus" })

		-- Registers
		vim.keymap.set("n", "<leader>or", builtin.registers, { desc = "[O]pen [R]egisters" })

		-- Jumps
		vim.keymap.set("n", "<leader>oj", builtin.jumplist, { desc = "[O]pen [J]umplist" })

		-- Diagnostics
		vim.keymap.set("n", "<leader>od", builtin.diagnostics, { desc = "[O]pen [D]iagnostics" })

		-- Current buffer
		vim.keymap.set("n", "<leader>sg", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[s]earch buffer with grep" })

		-- Search Neovim config files
		vim.keymap.set("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
