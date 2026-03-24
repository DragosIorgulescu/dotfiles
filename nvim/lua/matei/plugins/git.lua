-- =============================================================================
-- Git — Gitsigns, Fugitive, Diffview
-- =============================================================================
return {
  -- Gitsigns (inline git blame, hunks, etc.)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged_enable = true,
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Previous hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff HEAD~")
        map("n", "<leader>htb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>htd", gs.toggle_deleted, "Toggle deleted")
      end,
    },
  },

  -- Fugitive (git wrapper)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GBrowse" },
    keys = {
      { "<leader>gg", "<cmd>Git<CR>", desc = "Git status (fugitive)" },
    },
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
      },
    },
  },
}
