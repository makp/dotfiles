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
	keys = {
		{
			"<localleader>ds",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<localleader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<localleader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<localleader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<localleader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<localleader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Breakpoint",
		},
		{
			"<localleader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Debug: Open REPL",
		},
		{
			"<localleader>dt",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: See last session result.",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Mason setup
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
