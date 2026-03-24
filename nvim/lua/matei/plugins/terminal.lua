-- =============================================================================
-- Terminal — ToggleTerm + Tmux navigation
-- =============================================================================
return {
  -- ToggleTerm (floating / horizontal / vertical terminals)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<CR>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical terminal" },
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Lazygit terminal
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = { border = "double" },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end, { desc = "Lazygit" })
    end,
  },

  -- Tmux navigation (seamless Ctrl-hjkl between vim and tmux panes)
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate left (tmux-aware)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate down (tmux-aware)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate up (tmux-aware)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (tmux-aware)" },
    },
  },
}
