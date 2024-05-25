-- Config for formatters
-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#lazy-loading-with-lazynvim
-- Run `ConformInfo` for checking the status of the formatters
return {
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
					-- Map of treesitter language to formatters to use
					-- (defaults to the value from formatters_by_ft)
					-- lang_to_formatters = {},
				},
			},
		},

		-- Define formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			json = { "jq" },
			markdown = { "mdformat", "injected" },
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
}
