-- =============================================================================
-- Go — Enhanced Go development
-- =============================================================================
return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      goimports = "gopls",
      gofmt = "gopls",
      tag_transform = false,
      test_dir = "",
      comment_placeholder = "   ",
      lsp_cfg = false,       -- we configure gopls in lsp.lua
      lsp_gofumpt = true,
      lsp_on_attach = false, -- we handle on_attach in lsp.lua
      dap_debug = true,
      lsp_keymaps = false,   -- we define keymaps in lsp.lua
      lsp_codelens = true,
      lsp_inlay_hints = { enable = true },
      diagnostic = false,    -- handled by lsp.lua
      trouble = true,
      luasnip = true,
    },
    keys = {
      { "<leader>cgt", "<cmd>GoTest<CR>", ft = "go", desc = "Go test" },
      { "<leader>cgT", "<cmd>GoTestFunc<CR>", ft = "go", desc = "Go test function" },
      { "<leader>cgr", "<cmd>GoRun<CR>", ft = "go", desc = "Go run" },
      { "<leader>cge", "<cmd>GoIfErr<CR>", ft = "go", desc = "Go if err" },
      { "<leader>cga", "<cmd>GoAddTag json<CR>", ft = "go", desc = "Go add tags" },
      { "<leader>cgA", "<cmd>GoRmTag<CR>", ft = "go", desc = "Go remove tags" },
      { "<leader>cgc", "<cmd>GoCoverage<CR>", ft = "go", desc = "Go coverage" },
      { "<leader>cgi", "<cmd>GoImpl<CR>", ft = "go", desc = "Go implement interface" },
      { "<leader>cgf", "<cmd>GoFillStruct<CR>", ft = "go", desc = "Go fill struct" },
    },
  },
}
