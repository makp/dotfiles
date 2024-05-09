-- Set up Lazy plugin manager
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

-- Load vim options
require("vim-options")

-- Load basic keymaps
require("basic_keymaps")

-- Load lua files in plugin folder
require("lazy").setup("plugins")

-- Load Lua helper functions
require("helper_funcs")
