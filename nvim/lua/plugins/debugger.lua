return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Debugger UI
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",

		-- Use Mason to install debug adapters
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- DAP extension for python
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			automatic_installation = true,

			handlers = {},

			-- Add the specific lang debuggers
			ensure_installed = { "python" },
		})

		-- Basic debugging keymaps
		vim.keymap.set("n", "<localleader>ds", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<localleader>di", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<localleader>dn", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<localleader>do", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<localleader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: Set Breakpoint" })
		vim.keymap.set("n", "<localleader>dr", dap.repl.open, { desc = "Debug: Open REPL" })

		-- Dap UI setup
		dapui.setup(
			-- 	{
			-- 	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			-- }
		)

		-- Toggle to see last session result. Without this, you can't see session
		-- output in case of unhandled exception.
		vim.keymap.set("n", "<localleader>dt", dapui.toggle, { desc = "Debug: See last session result." })

		-- Use DAP events to open and close the UI
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
