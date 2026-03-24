-- =============================================================================
-- Formatting & Linting — conform.nvim + nvim-lint
-- =============================================================================
return {
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        ruby = { "rubocop" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        python = { "ruff_format", "ruff_fix" },
        rust = { "rustfmt" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        sql = { "sql_formatter" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        go = { "golangcilint" },
        ruby = { "rubocop" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        python = { "ruff" },
        terraform = { "tflint" },
        dockerfile = { "hadolint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        yaml = { "yamllint" },
      }

      -- Auto-lint on save / insert leave
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("Linting", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
