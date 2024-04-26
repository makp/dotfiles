return {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Comment
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Autopair
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			require("nvim-autopairs").setup({})
			-- Automatically add `(` after selecting a function or method
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Autoformat
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>rf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},

	-- Highlight TODOs in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Add indentation guides even on blank lines
	{
		"lukas-reineke/indent-blankline.nvim",
		-- See `:help ibl`
		main = "ibl",
		opts = {},
	},

	-- Interactive REPLs
	{
		"Vigemus/iron.nvim",
		config = function()
			require("iron.core").setup({
				config = {
					-- Highlight the last sent block with bold
					highlight_last = "IronLastSent",
					-- Discard repl?
					scratch_repl = true,
					-- Close repl window on process end
					close_window_on_exit = true,
					-- repls
					repl_definition = {
						sh = {
							command = { "zsh" },
						},
						python = require("iron.fts.python").ipython,
					},
					--
					-- How repl window will be displayed
					--
					repl_open_cmd = require("iron.view").bottom(15),
					--
					-- Ignore blank lines when senting visual lines?
					ignore_blank_lines = true,
				},
				-- keymaps
				keymaps = {
					send_motion = "<space>sc",
					visual_send = "<space>sc",
					send_file = "<space>sf",
					send_line = "<space>sl",
					send_until_cursor = "<space>su",
					send_mark = "<space>sm",
					mark_motion = "<space>mc",
					mark_visual = "<space>mc",
					remove_mark = "<space>md",
					cr = "<space>s<cr>",
					interrupt = "<space>s<space>",
					exit = "<space>sq",
					clear = "<space>cl",
				},
				-- Highlight (check nvim_set_hl)
				highlight = {
					italic = true,
				},
			})

			-- See :h iron-commands for all available commands
			vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
			vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
			vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
			vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		end,
	},

	-- Display pending keybindins
	-- {
	--   'folke/which-key.nvim',
	--   event = 'VimEnter', -- Sets the loading event to 'VimEnter'
	--   config = function() -- This is the function that runs, AFTER loading
	--     require('which-key').setup()
	--
	--     -- Document existing key chains
	--     require('which-key').register {
	--       ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
	--       ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
	--       ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
	--       ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
	--       ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
	--       ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
	--       ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
	--     }
	--     -- visual mode
	--     require('which-key').register({
	--       ['<leader>h'] = { 'Git [H]unk' },
	--     }, { mode = 'v' })
	--   end,
	-- },
}
