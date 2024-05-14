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

				-- Hunk operations
				-- Visual mode
				map("v", "<localleader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				map("v", "<localleader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end)
				-- Normal mode
				map("n", "<localleader>hs", function()
					gitsigns.stage_hunk()
					vim.cmd.normal("]h")
				end)
				map("n", "<localleader>hu", gitsigns.undo_stage_hunk) -- undo last stage_hunk
				map("n", "<localleader>hS", gitsigns.stage_buffer)
				map("n", "<localleader>hr", gitsigns.reset_hunk) -- at the cursor position
				map("n", "<localleader>hR", gitsigns.reset_buffer)

				-- Diffs
				map("n", "<localleader>hp", gitsigns.preview_hunk)
				map("n", "<localleader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
				map("n", "<localleader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })

				-- Blame
				map("n", "<localleader>hb", function()
					gitsigns.blame_line({ full = true })
				end)

				-- Toggles
				map("n", "<localleader>htb", gitsigns.toggle_current_line_blame)
				map("n", "<localleader>htd", gitsigns.toggle_deleted)
				map("n", "<localleader>htw", gitsigns.toggle_word_diff)

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
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
