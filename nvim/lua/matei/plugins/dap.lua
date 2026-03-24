-- =============================================================================
-- DAP — Debug Adapter Protocol
-- =============================================================================
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
        end,
      },
      -- Virtual text
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      -- Go
      { "leoluz/nvim-dap-go", opts = {} },
      -- Mason integration
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          ensure_installed = { "delve", "node2", "python" },
        },
      },
    },
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      -- Breakpoint icons
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
    end,
  },
}
