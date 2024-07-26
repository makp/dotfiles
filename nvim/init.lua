-- Main entry point for neovim configuration
-- !ln -s %:p:h $HOME/.config/nvim

-- Change nvim default behavior
require("vim-options")

-- Add keymaps not requiring plugins
require("keymaps_sans_plugins")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Load lua files in plugin folder
require("lazy").setup("plugins")

-- Run certain routines after LSP attach
require("lsp_after_attach")

-- Load Lua helper functions
require("helper_funcs")
