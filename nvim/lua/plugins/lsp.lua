-- LSP Configuration & Plugins
-- From kickstart
-- TODO:
-- -- Find an easier way to commit staged changes. Maybe through Telescope?
-- -- Maybe integrate LSP with breadcrumb-like feature. Maybe nvim.navic?
--
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Install LSPs
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Display notifications LSP progress
		{ "j-hui/fidget.nvim", opts = {} },

		-- Configure Lua LSP for Neovim config, runtime and plugins
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		--  This function runs when an LSP attaches to a particular buffer.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- Create function to define LSP-specific mappings.
				-- It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Jump to the definition of the word under your cursor
				--  Press <C-t> to jump back
				map("gd", require("telescope.builtin").lsp_definitions, "jump to [d]efinition")

				-- Find references for the word under your cursor.
				map("gr", require("telescope.builtin").lsp_references, "jump to [r]eferences")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<localleader>cs", require("telescope.builtin").lsp_document_symbols, "[s]ymbols in current buffer")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map(
					"<localleader>cS",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[S]ymbols in workspace"
				)

				-- Jump to the declaration of the word under your cursor
				--  For example, in C this would take you to the header.
				map("<localleader>cD", vim.lsp.buf.declaration, "jump to [D]eclaration")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation
				map("<localleader>cI", require("telescope.builtin").lsp_implementations, "jump to [I]mplementation")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("<localleader>cT", require("telescope.builtin").lsp_type_definitions, "jump to [T]ype")

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<localleader>cr", vim.lsp.buf.rename, "[r]ename variable")

				-- Execute a code action
				map("<localleader>ca", vim.lsp.buf.code_action, "execute [a]ction")

				-- Opens a popup with documentation about the word under your cursor
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- The following two autocommands are used to highlight references of
				-- the word under your cursor when your cursor rests there for a little
				-- while. See `:help cursorhold` for information about when this is
				-- executed
				--
				-- when you move your cursor, the highlights will be cleared (the
				-- second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documenthighlightprovider then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "cursorhold", "cursorholdi" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- Enable inlay hints in your code
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<localleader>ct", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[t]oggle inlay hints")
				end
			end,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
			callback = function(event)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
			end,
		})

		--  By default, Neovim doesn't support everything that is in the LSP
		--  specification. When you add nvim-cmp, luasnip, etc. Neovim now has
		--  *more* capabilities. So, we create new capabilities with nvim cmp, and
		--  then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable the following language servers
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		local servers = {
			-- See `:help lspconfig-all` for a list of all the pre-configured LSPs

			pylsp = {},
			texlab = {
				settings = {
					texlab = {
						chktex = {
							onEdit = true,
							onOpenAndSave = true,
						},
						forwardSearch = {
							executable = "zathura",
							args = { "--synctex-forward", "%l:1:%f", "%p" },
						},
					},
				},
			},
			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		-- Add other tools for Mason to install
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
