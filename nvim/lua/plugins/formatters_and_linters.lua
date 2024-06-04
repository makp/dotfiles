return {
	-- Config for formatters
	-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
	-- Run `ConformInfo` for checking the status of the formatters
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		-- lazy = false,
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
			formatters = {
				injected = {
					opts = {
						lang_to_ext = {
							bash = "sh",
							javascript = "js",
							latex = "tex",
							markdown = "md",
							python = "py",
						},
					},
				},
			},

			-- Define formatters
			formatters_by_ft = {
				sh = { "shfmt" },
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				json = { "jq" },
				markdown = { "markdownlint", "injected" },
				-- tex = { "latexindent" }, -- texlab already does this
				bib = { "bibtex-tidy" }, -- `bibtex-tidy` times out on large files
				-- Run `trim_whitespace` on all files
				["*"] = { "trim_whitespace" },
				-- Run `` on all files that don't have a formatter configured
				-- ["_"] = { "" },
			},
			-- Set up formats on save
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
		},
	},
	{
		-- Linters
		-- `nvim-lint` reports its results through the `vim.diagnostic` module.
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				json = { "jsonlint" },
				python = { "ruff" },
				-- tex = { "chktex" }, -- texlab is set to run chktex
				-- markdown = { "vale" },
				-- text = { "vale" },
			}

			-- Create autocommand which carries out the actual linting
			-- on specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Run linters as defined by `lint.linters_by_ft`
					require("lint").try_lint()
					-- Run `codespell` on all files
					-- require("lint").try_lint({ "codespell" })
				end,
			})
		end,
	},
	{
		-- Make sure linters and formatters are installed
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			-- Mason - Installer for third-party tools
			-- Tools are saved in `~/.local/share/nvim/mason/packages`
			"WhoIsSethDaniel/mason.nvim",
			config = true,
		},
		config = function()
			-- Setup Mason
			-- Tools are saved in `~/.local/share/nvim/mason/packages`
			require("mason").setup()

			-- Get all formatters and linters
			local linters_and_formatters = {}
			local formatters = require("conform").formatters_by_ft
			local formatters_to_exclude = { "injected", "trim_whitespace", "ruff_organize_imports", "ruff_format" }
			for _, tbl in pairs(formatters) do
				for _, formatter in ipairs(tbl) do
					local add_formatter = true
					for _, formatter_to_exclude in ipairs(formatters_to_exclude) do
						if formatter == formatter_to_exclude then
							add_formatter = false
							break
						end
					end
					if add_formatter then
						table.insert(linters_and_formatters, formatter)
					end
				end
			end

			local linters = require("lint").linters_by_ft
			for _, tbl in pairs(linters) do
				for _, linter in ipairs(tbl) do
					table.insert(linters_and_formatters, linter)
				end
			end

			local other_tools_tbl = {}
			for _, tool in ipairs(other_tools_tbl) do
				table.insert(linters_and_formatters, tool)
			end

			require("mason-tool-installer").setup({
				ensure_installed = linters_and_formatters,
				auto_update = true,
				integrations = {
					["mason-lspconfig"] = false,
					["mason-nvim-dap"] = false,
				},
			})
		end,
	},
}
