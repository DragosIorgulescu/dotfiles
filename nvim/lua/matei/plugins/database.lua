-- =============================================================================
-- Database — vim-dadbod (SQL client) + UI + completion
-- =============================================================================
-- The LazyVim "lang.sql" extra bundles these three plugins; since this is a
-- plain lazy.nvim config (not the LazyVim distro), we declare them directly.
--
-- Usage:
--   <leader>D  (or :DBUIToggle)   → open the connections / schema sidebar
--   :DBUIAddConnection            → add + persist a connection interactively
--   :DB <url> <query>             → run a one-off query
--   In a .sql buffer: write SQL, then <leader>S (dadbod-ui default) to execute.
--
-- Connections are resolved from (any of):
--   • DBUI's saved store  → g:db_ui_save_location (below; lives outside this repo)
--   • the $DATABASE_URL env var
--   • g:dbs  (a table of named URLs)
-- Keep credentials OUT of this repo: put `export DATABASE_URL=...` in
-- ~/.zshrc.local (already sourced, untracked) or a project .envrc (direnv).
--
-- Clients: dadbod shells out to psql / mysql / sqlite3 (all on PATH already).
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI (database)" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_execute_on_save = false -- don't auto-run queries on :w

      -- Wire vim-dadbod-completion into nvim-cmp for SQL buffers.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        group = vim.api.nvim_create_augroup("matei_dadbod_cmp", { clear = true }),
        callback = function()
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({
              sources = {
                { name = "vim-dadbod-completion" },
                { name = "luasnip" },
                { name = "buffer", keyword_length = 3 },
              },
            })
          end
        end,
      })
    end,
  },
}
