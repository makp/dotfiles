return {
	"declancm/maximize.nvim",
	config = function()
		vim.keymap.set("n", "<C-w>z", function()
			require("maximize").toggle()
		end, { desc = "Toggle maximize window" })
	end,
}
