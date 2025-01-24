return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			"<leader>u",
			"<leader>e",
			"<localleader>u",
			"<localleader>a",
			"<leader>o",
			"<leader>d",
			"<localleader>e",
			"z=",
			"<C-\\>",
		},
		config = function()
			local fzflua = require("fzf-lua")

			fzflua.setup({
				keymap = {
					builtin = {
						["<F1>"] = "toggle-help",
						["<C-z>"] = "toggle-fullscreen",
						-- Only valid with the 'builtin' previewer
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

					-- fzf '--bind=' options
					fzf = {
						["ctrl-f"] = "half-page-down",
						["ctrl-b"] = "half-page-up",
						["ctrl-a"] = "beginning-of-line",
						["ctrl-e"] = "end-of-line",
						["alt-a"] = "toggle-all",
						-- Only valid with fzf previewers (bat/cat/git/etc)
						["alt-w"] = "toggle-preview-wrap",
						["f4"] = "toggle-preview",
						["ctrl-d"] = "preview-page-down",
						["ctrl-u"] = "preview-page-up", -- it was "unix-line-discard"
					},
				},
				-- "accept" mappings
				actions = {
					files = {
						true, -- inherit default mappings
						["alt-s"] = fzflua.actions.file_split,
						["alt-v"] = fzflua.actions.file_vsplit,
					},
				},
			})
			-- Run
			vim.keymap.set("n", "<leader>uc", fzflua.commands, { desc = "commands" })
			vim.keymap.set("n", "<leader>ur", fzflua.command_history, { desc = "command from history" })
			vim.keymap.set("n", "<leader>uf", fzflua.builtin, { desc = "[f]zf-lua" })
			vim.keymap.set("n", "<leader>uF", fzflua.resume, { desc = "[r]esume" })

			-- Help with
			vim.keymap.set("n", "<leader>et", fzflua.helptags, { desc = "[t]ags" })
			vim.keymap.set("n", "<leader>ek", fzflua.keymaps, { desc = "[k]eymaps" })
			vim.keymap.set("n", "<leader>em", fzflua.manpages, { desc = "[m]an pages" })

			-- Paste
			vim.keymap.set("n", "<leader>ar", fzflua.registers, { desc = "[r]egisters" })
			vim.keymap.set("n", "<leader>al", fzflua.complete_line, { desc = "[l]ines" })
			vim.keymap.set("n", "<leader>ap", fzflua.complete_path, { desc = "complete [p]ath" })
			vim.keymap.set("i", "<C-\\>p", fzflua.complete_path, { desc = "complete [p]ath" })

			-- Jump to
			vim.keymap.set("n", "<localleader>uf", fzflua.files, { desc = "[f]iles in cwd" })
			vim.keymap.set("n", "<localleader>ub", fzflua.buffers, { desc = "[b]uffers" })
			vim.keymap.set("n", "<localleader>ur", function()
				fzflua.oldfiles({ cwd_only = true, prompt = "History (CWD)❯ " })
			end, { desc = "[r]ecent files in cwd" })
			vim.keymap.set("n", "<localleader>uR", fzflua.oldfiles, { desc = "[r]ecent files" })

			-- Search
			vim.keymap.set("n", "<localleader>ab", fzflua.lgrep_curbuf, { desc = "current [b]uffer" })
			vim.keymap.set("n", "<localleader>af", fzflua.live_grep, { desc = "[f]iles in cwd" })
			vim.keymap.set("n", "<localleader>aw", fzflua.grep_cword, { desc = "files containing [w]ord" })
			vim.keymap.set("n", "<localleader>aW", fzflua.grep_cWORD, { desc = "files containing [W]ORD" })
			vim.keymap.set("n", "<localleader>an", fzflua.treesitter, { desc = "treesitter [n]odes" })

			-- Review
			vim.keymap.set("n", "<localleader>ed", fzflua.git_status, { desc = "[d]iffs" })
			vim.keymap.set("n", "<localleader>ec", fzflua.git_commits, { desc = "[c]ommits" })
			vim.keymap.set("n", "<localleader>eb", fzflua.git_branches, { desc = "[b]ranghes" })
			vim.keymap.set("n", "<localleader>er", function()
				fzflua.command_history({ query = "^G " }) -- Restrict to fugitive cmds
			end, { desc = "Run git cmd from history" })

			-- Open
			vim.keymap.set("n", "<leader>oj", fzflua.jumps, { desc = "[j]umplist" })

			-- Diagnostics
			vim.keymap.set("n", "<leader>db", fzflua.diagnostics_document, { desc = "jump in current [b]uffer" })
			vim.keymap.set("n", "<leader>dw", fzflua.diagnostics_workspace, { desc = "jump in [w]orkspace" })

			-- Spell
			vim.keymap.set("n", "z=", fzflua.spell_suggest, { desc = "spell check" })

			-- Completetion

			-- fzf-bibtex configuration
			require("fzf-bibtex_config")
		end,
	},
}
