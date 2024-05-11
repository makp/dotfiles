-- Syntax
return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			-- Repeat movement with ; and ,
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
		end,
	},
	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_surrround_enabled = 1
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"vim",
				"vimdoc",
				"python",
				"latex",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,

			-- Ignore orgmode (suggested by orgmode plugin)
			ignore_install = { "org" },

			-- Syntax highlighting
			highlight = {
				enable = true,
			},

			-- Indentation for the = operator
			indent = {
				enable = true,
			},

			-- Incremental selection
			incremental_selection = {
				enable = true,
				keymaps = {
					-- Start incremental selection (normal mode)
					init_selection = "gnn",
					-- Increment to the upper named parent (visual mode)
					node_incremental = "grn",
					-- Increment to the upper scope (visual mode)
					scope_incremental = "grc",
					-- Decrement to the previous named node (visual mode)
					node_decremental = "grm",
				},
			},

			-- Treesitter textobjects
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobjects
					lookahead = true,

					keymaps = {
						-- Capture groups are defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",

						["ac"] = "@comment.outer",
						["ic"] = "@comment.inner",

						["aa"] = "@assignment.outer",
						["ia"] = "@assignment.inner",

						["at"] = "@statement.outer",
						["it"] = "@statement.inner",

						["a,"] = "@parameter.outer",
						["i,"] = "@parameter.inner",

						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",

						["a["] = "@block.outer",
						["i["] = "@block.inner",
						-- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
						-- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@comment.outer",
						["]a"] = "@assignment.outer",
						["]t"] = "@statement.outer",
						["],"] = "@parameter.outer",
						["]i"] = "@conditional.outer",
						["]]"] = "@block.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]C"] = "@comment.outer",
						["]A"] = "@assignment.outer",
						["]T"] = "@statement.outer",
						["]<"] = "@parameter.outer",
						["]I"] = "@conditional.outer",
						["]["] = "@block.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[c"] = "@comment.outer",
						["[a"] = "@assignment.outer",
						["[t"] = "@statement.outer",
						["[,"] = "@parameter.outer",
						["[i"] = "@conditional.outer",
						["[["] = "@block.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[C"] = "@comment.outer",
						["[A"] = "@assignment.outer",
						["[T"] = "@statement.outer",
						["[<"] = "@parameter.outer",
						["[I"] = "@conditional.outer",
						["[]"] = "@block.outer",
					},
				},
			},

			-- Extend % motion
			-- % / g% : Go forwards/backwards
			-- [% / %] : Go previous/next outer open/close word
			-- z% : Go inside nearest block
			-- ds% / cs% : Delete/change surrounding block
			-- a% / i% : Select inside/outer block
			matchup = {
				enable = true,
			},
		},
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		-- Run :TSModuleInfo to check if a module is enabled
		config = function(_, opts)
			-- Prefer git instead of curl in order to improve connectivity in some environments
			require("nvim-treesitter.install").prefer_git = true

			-- Setup nvim-treesitter
			require("nvim-treesitter.configs").setup(opts)

			-- Search with treesitter
			vim.keymap.set(
				"n",
				"<leader>st",
				require("telescope.builtin").treesitter,
				{ desc = "[S]earch with [T]reesitter" }
			)
		end,
	},
}
