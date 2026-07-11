-- =============================================================================
-- Colorscheme — Clean dark (black background, minimal colors)
-- =============================================================================
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      theme = "dragon",
      background = { dark = "dragon" },
      colors = {
        theme = {
          dragon = {
            ui = {
              bg = "#000000",
              bg_dim = "#000000",
              bg_gutter = "#000000",
              bg_m3 = "#070707",
              bg_m2 = "#0a0a0a",
              bg_m1 = "#0e0e0e",
              bg_p1 = "#111111",
              bg_p2 = "#1a1a1a",
            },
          },
        },
      },
      overrides = function(colors)
        return {
          NormalFloat = { bg = "#0a0a0a" },
          FloatBorder = { bg = "#0a0a0a" },
          TelescopeNormal = { bg = "#000000" },
          TelescopeBorder = { bg = "#000000" },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },
}
