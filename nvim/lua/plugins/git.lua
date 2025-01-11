return {
	-- Use signs to show git info
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
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
				local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
				local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(function()
					gitsigns.nav_hunk("next")
				end, function()
					gitsigns.nav_hunk("prev")
				end)
				vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat)
				vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat)

				-- map("n", "]h", function()
				-- 	if vim.wo.diff then
				-- 		vim.cmd.normal({ "]h", bang = true })
				-- 	else
				-- 		gitsigns.nav_hunk("next")
				-- 	end
				-- end, { desc = "Jump to NEXT git hunk" })

				-- map("n", "[h", function()
				-- 	if vim.wo.diff then
				-- 		vim.cmd.normal({ "[h", bang = true })
				-- 	else
				-- 		gitsigns.nav_hunk("prev")
				-- 	end
				-- end, { desc = "Jump to PREVIOUS git hunk" })

				map("n", "]H", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]H", bang = true })
					else
						gitsigns.nav_hunk("last")
					end
				end, { desc = "Jump to LAST git hunk" })

				map("n", "[H", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[H", bang = true })
					else
						gitsigns.nav_hunk("first")
					end
				end, { desc = "Jump to FIRST git hunk" })

				-- Hunk operations
				-- Visual mode
				map("v", "<localleader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[s]tage hunk" })
				map("v", "<localleader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[r]eset hunk" })
				-- Normal mode
				map("n", "<localleader>h<space>", function()
					gitsigns.stage_hunk()
					vim.cmd.normal("]h")
				end)
				map("n", "<localleader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
				map("n", "<localleader>hu", gitsigns.undo_stage_hunk, { desc = "undo stage hunk" })
				map("n", "<localleader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })
				map("n", "<localleader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
				map("n", "<localleader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })

				-- Diffs
				map("n", "<localleader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
				map("n", "<localleader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
				map("n", "<localleader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })

				-- Blame
				map("n", "<localleader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "git [b]lame line" })

				-- Toggles
				map("n", "<localleader>htb", gitsigns.toggle_current_line_blame, { desc = "toggle [b]lame line" })
				map("n", "<localleader>htd", gitsigns.toggle_deleted, { desc = "toggle [d]eleted" })
				map("n", "<localleader>htw", gitsigns.toggle_word_diff, { desc = "toggle [w]ord diff" })

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
