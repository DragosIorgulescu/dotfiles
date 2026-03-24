-- =============================================================================
-- Colorscheme — Catppuccin (Mocha)
-- =============================================================================
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      dim_inactive = { enabled = true, percentage = 0.15 },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        functions = { "bold" },
        keywords = { "bold", "italic" },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        indent_blankline = { enabled = true },
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true },
        noice = true,
        notify = true,
        mini = { enabled = true },
        harpoon = true,
        flash = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
