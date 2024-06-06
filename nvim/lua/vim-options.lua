-- Setting options
-- See `:help vim.opt` and `:help option-list`

-- Configure indentation
vim.opt.expandtab = true -- Insert spaces when <Tab> is pressed
vim.opt.tabstop = 2 -- <Tab> width
vim.opt.softtabstop = 2 -- Number of spaces for each <Tab> press
vim.opt.shiftwidth = 2 -- Number of spaces with < and > cmds

vim.g.markdown_indent_level = 2 -- Default is 4

-- Set how neovim displays certain whitespace chars in the editor
--  See `:help 'list'` and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Use relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Decrease update time
vim.opt.updatetime = 250

-- Enable mouse mode (e.g., useful for line splits)
vim.opt.mouse = "a"

-- Sync OS and Nvim clipboard
vim.opt.clipboard = "unnamedplus"

-- Use nerd font
vim.g.have_nerd_font = true

-- Enable breakindent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Don't show the mode, since it's already in the status line
-- vim.opt.showmode = false

-- Case-insensitive searching unless \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live as you type
vim.opt.inccommand = "split"

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Set spell language
vim.opt.spelllang = "en_us"

-- Enable folding in markdown buffers
vim.g.markdown_folding = 1

-- Wrap lines at word boundaries
vim.opt.linebreak = true

-- Autocommands
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Don't automatically create commented lines with 'o'/'O' commds in Lua
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.formatoptions:remove("o")
	end,
})
