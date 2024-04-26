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
