-- =============================================================================
-- Telescope — Fuzzy finder (core TJ DeVries plugin)
-- =============================================================================
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-x>"] = actions.delete_buffer,
              ["<C-s>"] = actions.select_horizontal,
            },
            n = {
              ["q"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "vendor/", "%.lock",
            "__pycache__", "%.pyc", ".terraform/",
          },
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          set_env = { ["COLORTERM"] = "truecolor" },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep = { additional_args = { "--hidden" } },
          buffers = { sort_lastused = true, sort_mru = true },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            themes.get_dropdown(),
          },
          file_browser = {
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "file_browser")

      -- Keymaps
      local builtin = require("telescope.builtin")
      local map = vim.keymap.set

      -- Find
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fw", builtin.grep_string, { desc = "Grep word under cursor" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
      map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
      map("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
      map("n", "<leader>fc", builtin.commands, { desc = "Commands" })
      map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
      map("n", "<leader>fm", builtin.marks, { desc = "Marks" })
      map("n", "<leader>ft", builtin.colorscheme, { desc = "Themes" })

      -- Git
      map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
      map("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
      map("n", "<leader>gS", builtin.git_status, { desc = "Git status" })

      -- File browser
      map("n", "<leader>fe", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { desc = "File browser" })

      -- Search in current buffer (TJ pattern)
      map("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Fuzzy search in buffer" })
    end,
  },
}
