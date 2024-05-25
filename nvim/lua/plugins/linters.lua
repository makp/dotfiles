-- Config for linters
-- `nvim-lint` reports its results through the `vim.diagnostic` module.
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			json = { "jsonlint" },
			markdown = { "markdownlint" },
			-- markdown = { "vale" },
			-- text = { "vale" },
		}

		-- Create autocommand which carries out the actual linting
		-- on the specified events.
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Run linters as defined by `lint.linters_by_ft`
				-- require("lint").try_lint()
				-- Run `codespell` on all files
				require("lint").try_lint({ "codespell" })
			end,
		})
	end,
}
