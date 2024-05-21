-- Main entry point for neovim configuration

-- Change nvim default behavior
require("vim-options")

-- Add keymaps not requiring plugins
require("keymaps_sans_plugins")

-- Main plugin manager (Lazy)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load lua files in plugin folder
require("lazy").setup("plugins")

-- Load Lua helper functions
require("helper_funcs")
