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
	-- Debugging keymaps
	keys = function(_, keys)
		local dap = require("dap")
		local dapui = require("dapui")
		return {
			{ "<localleader>ds", dap.continue, desc = "Debug: Start/Continue" },
			{ "<localleader>di", dap.step_into, desc = "Debug: Step Into" },
			{ "<localleader>dn", dap.step_over, desc = "Debug: Step Over" },
			{ "<localleader>do", dap.step_out, desc = "Debug: Step Out" },
			{ "<localleader>db", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
			{
				"<localleader>dB",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Breakpoint",
			},
			{ "<localleader>dr", dap.repl.open, desc = "Debug: Open REPL" },

			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			{ "<localleader>dt", dapui.toggle, desc = "Debug: See last session result." },
			unpack(keys),
		}
	end,
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			automatic_installation = true,

			handlers = {},

			-- Add the specific lang debuggers
			ensure_installed = { "python" },
		})

		-- Dap UI setup
		dapui.setup(
			-- 	{
			-- 	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			-- }
		)

		-- Use DAP events to open and close the UI
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
