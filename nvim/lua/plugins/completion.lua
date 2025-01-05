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
					-- Build step is needed for regex support in snippets.
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- Snippet collection
					"rafamadriz/friendly-snippets",
				},
			},
			-- Use snippets during auto-completion
			"saadparwaiz1/cmp_luasnip",

			-- LSP completion
			"hrsh7th/cmp-nvim-lsp",

			-- Spell
			"f3fora/cmp-spell",

			-- Paths of files and folders
			"hrsh7th/cmp-path",

			-- Buffer words
			"hrsh7th/cmp-buffer",

			-- Command line completion
			"hrsh7th/cmp-cmdline",

			-- Icons for LSP completion
			"onsails/lspkind-nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/" } })

			cmp.setup({
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
					}),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				-- See `:help completeopt`
				-- menu: show completion menu
				-- menuone: show completion even when there is only one item
				-- noselect: prevents auto-select the first completion
				-- noinsert: prevents auto-insert the first completion
				completion = { completeopt = "menu,menuone,noselect" },
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				-- `:help ins-completion`
				mapping = {
					["<C-S-n>"] = cmp.mapping.complete(),

					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),

					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

					-- Scroll the documentation window
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),

					-- Accept completion
					["<Tab>"] = cmp.mapping(
						cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Insert,
							select = true,
						}),
						{ "i", "c" }
					),

					["<C-e>"] = cmp.mapping(function()
						if luasnip.choice_active() then
							luasnip.change_choice(1)
						end
					end, { "i", "s" }),

					["<C-y>"] = cmp.mapping(function()
						if luasnip.choice_active() then
							luasnip.change_choice(-1)
						end
					end, { "i", "s" }),

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
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer", keyword_length = 4 },
					{ name = "path" },
				}),
			})

			-- Setup for text-based filetypes
			cmp.setup.filetype({ "markdown", "latex", "org" }, {
				completion = {
					keyword_length = 2,
				},
				sources = cmp.config.sources({
					{ name = "spell" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			-- `/` cmdline setup
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer", max_item_count = 13 },
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
						max_item_count = 13,
						keyword_length = 1,
					},
				}),
				-- matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	-- Enable Copilot completions
	{
		"github/copilot.vim",
		-- Type `# q:` for asking questions
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
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			model = "claude-3.5-sonnet",
		},
		keys = {
			{
				"<localleader>cct",
				"<cmd>CopilotChatToggle<cr>",
				mode = { "n", "v" },
				desc = "[t]oggle coding chat",
			},
			{
				"<localleader>cca",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
				end,
				desc = "Select [a]ction for chat",
			},
		},
	},
}
