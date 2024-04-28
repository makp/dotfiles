return {
	-- Use signs to show git info
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				-- Define func to set up keymaps
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Hunk navigation
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]h", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [h]unk" })

				map("n", "]H", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]H", bang = true })
					else
						gitsigns.nav_hunk("last")
					end
				end, { desc = "Jump to last git [h]unk" })

				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[h", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [h]unk" })

				map("n", "[H", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[H", bang = true })
					else
						gitsigns.nav_hunk("first")
					end
				end, { desc = "Jump to first git [h]unk" })

				-- Actions
				-- Visual mode
				map("v", "<localleader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("v", "<localleader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				-- Normal mode
				map("n", "<localleader>gs", gitsigns.stage_hunk)
				map("n", "<localleader>gu", gitsigns.undo_stage_hunk) -- undo last stage_hunk
				map("n", "<localleader>gS", gitsigns.stage_buffer)
				map("n", "<localleader>gr", gitsigns.reset_hunk) -- at the cursor position
				map("n", "<localleader>gR", gitsigns.reset_buffer)
				map("n", "<localleader>gp", gitsigns.preview_hunk)
				map("n", "<localleader>gb", function()
					gitsigns.blame_line({ full = true })
				end)
				map("n", "<localleader>gd", gitsigns.diffthis, { desc = "git [d]iff against index" })
				map("n", "<localleader>gD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })
				--
				-- Toggles
				map("n", "<localleader>gtb", gitsigns.toggle_current_line_blame)
				map("n", "<localleader>gtd", gitsigns.toggle_deleted)
				map("n", "<localleader>gtw", gitsigns.toggle_word_diff)

				-- Hunk object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},

	-- Lazygit
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<localleader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
