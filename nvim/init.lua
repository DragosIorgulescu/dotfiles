-- =============================================================================
-- Matei's Neovim Configuration
-- Inspired by TJ DeVries' kickstart.nvim and personal config patterns
-- =============================================================================
-- Structure:
--   init.lua              → bootstrap lazy.nvim, load core settings
--   lua/matei/options.lua → vim options
--   lua/matei/keymaps.lua → key mappings
--   lua/matei/autocmds.lua→ autocommands
--   lua/matei/plugins/    → one file per plugin (or logical group)
--   lua/matei/lsp/        → LSP configurations
-- =============================================================================

-- Set leader BEFORE anything else (TJ pattern)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Load core modules
require("matei.options")
require("matei.keymaps")
require("matei.autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/matei/plugins/
require("lazy").setup({
  spec = {
    { import = "matei.plugins" },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen",
        "netrwPlugin", "tarPlugin", "tohtml",
        "tutor", "zipPlugin",
      },
    },
  },
})
