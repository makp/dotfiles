-- fzf-bibtex configuration
--

local fzflua = require("fzf-lua")

-- Default list of bibfiles
-- Can be overriden by changing vim.b.bibfiles inside buffer
local default_bibfiles = {
	"/home/makmiller/Documents/mydocs/tex-configs/references/evol.bib",
}

-- Default cache directory
-- Uses neovim's stdpath to set up a cache - no need to fiddle with this
local cachedir = vim.fn.stdpath("state") .. "/fzf-bibtex/"

-- Actions
local cite = function(cmd, selected, opts)
	local result = vim.fn.system(cmd, selected)
	vim.api.nvim_put({ result }, "c", false, true)
	if opts.fzf_bibtex.mode == "i" then
		vim.api.nvim_feedkeys("i", "n", true)
	end
end

local pandoc = function(selected, opts)
	cite("bibtex-cite", selected, opts)
end

local citet = function(selected, opts)
	local cmd = 'bibtex-cite -prefix="\\citet{" -postfix="}" -separator=","'
	cite(cmd, selected, opts)
end

local citep = function(selected, opts)
	local cmd = 'bibtex-cite -prefix="\\citep{" -postfix="}" -separator=","'
	cite(cmd, selected, opts)
end

local markdown_print = function(selected, opts)
	local result =
		vim.fn.system("bibtex-markdown -cache=" .. cachedir .. " " .. table.concat(vim.b.bibfiles, " "), selected)
	local result_lines = {}
	for line in result:gmatch("[^\n]+") do
		table.insert(result_lines, line)
	end
	vim.api.nvim_put(result_lines, "l", true, true)
	if opts.fzf_bibtex.mode == "i" then
		vim.api.nvim_feedkeys("i", "n", true)
	end
end

local fzf_bibtex_menu = function(mode)
	return function()
		-- Check cache directory hasn't mysteriously disappeared
		if vim.fn.isdirectory(cachedir) == 0 then
			vim.fn.mkdir(cachedir, "p")
		end

		-- List actions' help strings
		local actions = {
			{ pandoc, "@-pandoc" },
			{ citet, "\\citet{}" },
			{ citep, "\\citep{}" },
			{ markdown_print, "markdown-pretty-print" },
		}
		for _, action in ipairs(actions) do
			fzflua.config.set_action_helpstr(action[1], action[2])
		end

		-- Header line: the bibtex filenames
		local filenames = {}
		for i, fullpath in ipairs(vim.b.bibfiles) do
			filenames[i] = vim.fn.fnamemodify(fullpath, ":t")
		end
		local header = table.concat(filenames, "\\ ")

		-- Set default action
		local default_action = nil
		if vim.bo.ft == "markdown" then
			default_action = markdown_print
		elseif vim.bo.ft == "tex" then
			default_action = citet
		end

		-- Run fzf
		return fzflua.fzf_exec("bibtex-ls " .. "-cache=" .. cachedir .. " " .. table.concat(vim.b.bibfiles, " "), {
			actions = {
				["default"] = default_action,
				["alt-@"] = pandoc,
				["alt-t"] = citet,
				["alt-p"] = citep,
				["alt-m"] = markdown_print,
			},
			fzf_bibtex = { ["mode"] = mode },
			fzf_opts = { ["--multi"] = true, ["--prompt"] = "BibTeX> ", ["--header"] = header },
		})
	end
end

-- Only enable mapping in tex or markdown
vim.api.nvim_create_autocmd("Filetype", {
	desc = "Set up keymaps for fzf-bibtex",
	group = vim.api.nvim_create_augroup("fzf-bibtex", { clear = true }),
	pattern = { "markdown", "tex" },
	callback = function()
		vim.b.bibfiles = default_bibfiles
		vim.keymap.set("n", "<localleader>r", fzf_bibtex_menu("n"), { buffer = true, desc = "FZF: BibTeX [C]itations" })
		vim.keymap.set("i", "@@", fzf_bibtex_menu("i"), { buffer = true, desc = "FZF: BibTeX [C]itations" })
	end,
})
