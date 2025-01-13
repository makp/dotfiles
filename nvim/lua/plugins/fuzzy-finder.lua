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
					fzf = { -- fzf '--bind=' options
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
			})
			-- Fzf-Lua keymaps
			vim.keymap.set("n", "<leader>rf", fzflua.builtin, { desc = "[f]zf-lua" })
			vim.keymap.set("n", "<leader>rF", fzflua.resume, { desc = "[r]esume" })

			-- Cmds
			vim.keymap.set("n", "<leader>rc", fzflua.commands, { desc = "commands" })
			vim.keymap.set("n", "<leader>rr", fzflua.command_history, { desc = "command history" })

			-- Help keymaps
			vim.keymap.set("n", "<leader>ht", fzflua.helptags, { desc = "[t]ags" })
			vim.keymap.set("n", "<leader>hk", fzflua.keymaps, { desc = "[k]eymaps" })
			vim.keymap.set("n", "<leader>hm", fzflua.manpages, { desc = "[m]an pages" })

			-- Find
			vim.keymap.set("n", "<leader>if", fzflua.files, { desc = "[f]iles in cwd" })
			vim.keymap.set("n", "<leader>ib", fzflua.buffers, { desc = "[b]uffers" })
			vim.keymap.set("n", "<leader>ir", function()
				return fzflua.oldfiles({ cwd_only = true, prompt = "History (CWD)❯ " })
			end, { desc = "[r]ecent files in cwd" })
			vim.keymap.set("n", "<leader>iR", fzflua.oldfiles, { desc = "[r]ecent files" })

			-- Grep
			vim.keymap.set("n", "<leader>eb", fzflua.lgrep_curbuf, { desc = "current [b]uffer" })
			vim.keymap.set("n", "<leader>ef", fzflua.live_grep, { desc = "[f]iles in cwd" })
			vim.keymap.set("n", "<leader>ew", fzflua.grep_cword, { desc = "files containing [w]ord" })
			vim.keymap.set("n", "<leader>eW", fzflua.grep_cWORD, { desc = "files containing [W]ORD" })
			vim.keymap.set("n", "<leader>en", fzflua.treesitter, { desc = "treesitter [n]odes" })

			-- Git
			vim.keymap.set("n", "<localleader>es", fzflua.git_status, { desc = "[s]tatus" })
			vim.keymap.set("n", "<localleader>ec", fzflua.git_commits, { desc = "[c]ommits" })
			vim.keymap.set("n", "<localleader>eb", fzflua.git_branches, { desc = "[b]ranghes" })
			vim.keymap.set("n", "<localleader>er", function()
				fzflua.command_history({ query = "^G " }) -- Restrict to fugitive cmds
			end, { desc = "Run git cmd from history" })

			-- Registers
			vim.keymap.set("n", "<leader>ur", fzflua.registers, { desc = "open [r]egisters" })

			-- Jumps
			vim.keymap.set("n", "<leader>uj", fzflua.jumps, { desc = "open [j]umplist" })

			-- Diagnostics
			vim.keymap.set("n", "<leader>db", fzflua.diagnostics_document, { desc = "jump in current [b]uffer" })
			vim.keymap.set("n", "<leader>dw", fzflua.diagnostics_workspace, { desc = "jump in [w]orkspace" })

			-- Spell
			vim.keymap.set("n", "z=", fzflua.spell_suggest, { desc = "spell check" })

			-- fzf-bibtex configuration
			require("fzf-bibtex_config")
		end,
	},
}
