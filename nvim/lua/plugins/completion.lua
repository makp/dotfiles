return {
	{
		-- Autocompletion engine
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet engine
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			-- Use snippets during auto-completion
			"saadparwaiz1/cmp_luasnip",

			-- LSP completion
			"hrsh7th/cmp-nvim-lsp",

			-- Paths of files and folders
			"hrsh7th/cmp-path",

			-- Buffer words
			"hrsh7th/cmp-buffer",

			-- Command line completion
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				-- `:help ins-completion`
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),

					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window [b]ack / [f]orward
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),

					-- Accept the completion
					-- ["<Tab>"] = cmp.mapping.confirm({ select = true }),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					-- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- `/` cmdline setup
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer", max_item_count = 7 },
				},
			})

			-- `:` cmdline setup
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path", max_item_count = 7 },
				}, {
					{
						name = "cmdline",
						max_item_count = 7,
						keyword_length = 2,
					},
				}),
				-- matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	-- Enable Copilot completions
	{
		"github/copilot.vim",
		-- M-]/[ : cycle through suggestions
		-- M-\ : request a suggestion
		-- M-Right / M-C-Right : accept next word/line
		-- Invoke :Copilot status to check the status of the plugin
		config = function()
			vim.g.copilot_no_mappings = true
			-- Open copilot panel with completions
			vim.keymap.set("i", "<C-\\>cc", "<cmd>Copilot panel<CR>")
			-- Don't use <Tab> to accept suggestion
			vim.g.copilot_no_tab_map = true
			-- Select a keybinding other than <Tab> to accept suggestion
			-- The argument to copilot#Accept() is the fallback for when no suggestion is
			-- displayed.
			-- vim.keymap.set("i", "<C-M-S-f>", 'copilot#Accept("\\<CR>")', {
			-- 	expr = true,
			-- 	replace_keycodes = false,
			-- })
			vim.keymap.set("i", "<C-f>", "<Plug>(copilot-accept-line)")
			vim.keymap.set("i", "<C-M-f>", "<Plug>(copilot-accept-word)")
		end,
	},
}
