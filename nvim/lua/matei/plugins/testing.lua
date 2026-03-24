-- =============================================================================
-- Testing — Neotest
-- =============================================================================
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "nvim-neotest/neotest-go",
      "olimorris/neotest-rspec",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
    keys = {
      { "<leader>Tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>Ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run all tests" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Output panel" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev failed test" },
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({ recursive_run = true }),
          require("neotest-rspec"),
          require("neotest-jest")({ jestCommand = "npx jest" }),
          require("neotest-python")({ dap = { justMyCode = false } }),
          require("neotest-rust"),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = { open = function() require("trouble").open({ mode = "quickfix", focus = false }) end },
      })
    end,
  },
}
