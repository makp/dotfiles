-- Syntax
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		"andymass/vim-matchup",
	},
	opts = {
		ensure_installed = {
			"c",
			"bash",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
			"query",
			"python",
			"latex",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,

		-- Syntax highlighting
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
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
				init_selection = "<C-Space>",
				-- Increment to the upper named parent (visual mode)
				node_incremental = "<C-Space>",
				-- Increment to the upper scope (visual mode)
				scope_incremental = "gss", -- `gs` is "goto sleep"
				-- Decrement to the previous named node (visual mode)
				node_decremental = "gsu",
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
					["aa"] = "@assignment.outer", -- assignment.lhs/rhs
					["ia"] = "@assignment.inner",

					["am"] = "@function.outer",
					["im"] = "@function.inner",

					["ar"] = "@return.outer",
					["ir"] = "@return.inner",

					["ac"] = "@class.outer",
					["ic"] = "@class.inner",

					["au"] = "@call.outer", -- func calls
					["iu"] = "@call.inner",

					["a,"] = "@parameter.outer",
					["i,"] = "@parameter.inner",

					["ae"] = "@statement.outer", -- there is no inner statement textobject

					["ax"] = "@block.outer",
					["ix"] = "@block.inner",

					["ai"] = "@conditional.outer",
					["ii"] = "@conditional.inner",

					["ao"] = "@loop.outer",
					["io"] = "@loop.inner",

					["in"] = "@number.inner", -- there is no outer number textobject

					["ak"] = "@comment.outer",
					["ik"] = "@comment.inner",

					-- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
					-- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- set jumps in the jumplist
				goto_next_start = {
					["]a"] = "@assignment.outer",
					["]m"] = "@function.outer",
					["]u"] = "@call.outer",
					["],"] = "@parameter.outer",
					["]e"] = "@statement.outer",
					["]i"] = "@conditional.outer",
					["]o"] = "@loop.outer",
					["]x"] = "@block.outer",
					["]n"] = "@number.inner",
					["]k"] = "@comment.outer",
				},
				goto_next_end = {
					["]A"] = "@assignment.outer",
					["]M"] = "@function.outer",
					["]U"] = "@call.outer",
					["]<"] = "@parameter.outer",
					["]E"] = "@statement.outer",
					["]I"] = "@conditional.outer",
					["]O"] = "@loop.outer",
					["]X"] = "@block.outer",
					["]N"] = "@number.inner",
					["]K"] = "@comment.outer",
				},
				goto_previous_start = {
					["[a"] = "@assignment.outer",
					["[m"] = "@function.outer",
					["[u"] = "@call.outer",
					["[,"] = "@parameter.outer",
					["[e"] = "@statement.outer",
					["[i"] = "@conditional.outer",
					["[o"] = "@loop.outer",
					["[x"] = "@block.outer",
					["[n"] = "@number.inner",
					["[k"] = "@comment.outer",
				},
				goto_previous_end = {
					["[A"] = "@assignment.outer",
					["[M"] = "@function.outer",
					["[U"] = "@call.outer",
					["[<"] = "@parameter.outer",
					["[E"] = "@statement.outer",
					["[I"] = "@conditional.outer",
					["[O"] = "@loop.outer",
					["[X"] = "@block.outer",
					["[N"] = "@number.inner",
					["[K"] = "@comment.outer",
				},
			},
		},

		-- Extend % motion
		-- % / g% : Go forwards/backwards
		-- [% / %] : Go previous/next outer open/close word
		-- z% : Go inside nearest block
		-- ds% / cs% : Delete/change surrounding block
		-- a% / i% : textobjects
		matchup = {
			enable = true,
		},
	},
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	-- Run :TSModuleInfo to check if a module is enabled
	config = function(_, opts)
		-- Setup base treesitter
		require("nvim-treesitter.configs").setup(opts)

		-- Repeat movement with ; and ,
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

		-- Add keys to view context
		vim.keymap.set("n", "[p", function()
			require("treesitter-context").go_to_context(vim.v.count1)
		end, { silent = true })

		vim.keymap.set("n", "[P", function()
			require("treesitter-context").go_to_context(-1)
		end, { silent = true })

		-- Matchup configuration
		vim.g.matchup_surrround_enabled = 1
	end,
}
