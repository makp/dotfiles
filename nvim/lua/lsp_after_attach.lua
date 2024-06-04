-- Routines after LSP attaches to a buffer

-- LSP keybindings
local function setup_mappings(buf)
	local telescope = require("telescope.builtin")

	local function map(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
	end

	local mappings = {
		--  Press <C-t> to jump back
		{ "gd", telescope.lsp_definitions, "jump to [d]efinition" },
		{ "gr", telescope.lsp_references, "jump to [r]eferences" },

		-- Fuzzy find all the symbols in your current document.
		-- Symbols are things like variables, functions, types, etc.
		{ "<localleader>cs", telescope.lsp_document_symbols, "[s]ymbols in current buffer" },

		-- Fuzzy find all the symbols in your current workspace.
		-- Similar to document symbols, except searches over your entire project.
		{ "<localleader>cS", telescope.lsp_dynamic_workspace_symbols, "[S]ymbols in workspace" },

		-- Jump to the declaration of the word under your cursor
		--  For example, in C this would take you to the header.
		{ "<localleader>cD", vim.lsp.buf.declaration, "jump to [D]eclaration" },

		-- Jump to the implementation of the word under your cursor.
		-- Useful when your language has ways of declaring types without an actual implementation
		{ "<localleader>cI", telescope.lsp_implementations, "jump to [I]mplementation" },

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		{ "<localleader>cT", telescope.lsp_type_definitions, "jump to [T]ype" },

		{ "<localleader>cr", vim.lsp.buf.rename, "[r]ename variable" },
		{ "<localleader>ca", vim.lsp.buf.code_action, "execute [a]ction" },
	}

	for _, map_args in ipairs(mappings) do
		map(unpack(map_args))
	end
end

-- The following autocommands are used to highlight references of the word
-- under your cursor when your cursor rests there for a little. When you move
-- your cursor, the highlights will be cleared (the second autocommand). See
-- `:help cursorhold` for information about when this is executed
local function highlight_references(buf)
	local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = buf,
		group = highlight_augroup,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		buffer = buf,
		group = highlight_augroup,
		callback = vim.lsp.buf.clear_references,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
		callback = function(event2)
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
		end,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		setup_mappings(event.buf)

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client then
			if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				highlight_references(event.buf)
			end

			-- Toggle inlay hints
			if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				vim.keymap.set("n", "<localleader>ct", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, { buffer = event.buf, desc = "LSP: " .. "[t]oggle inlay hints" })
			end
		end
	end,
})
