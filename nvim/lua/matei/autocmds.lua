-- =============================================================================
-- Autocommands — TJ DeVries patterns
-- =============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank (from TJ's kickstart)
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Resize splits on window resize
augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group = "ResizeSplits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last location when opening a buffer
augroup("LastLocation", { clear = true })
autocmd("BufReadPost", {
  group = "LastLocation",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with q
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = {
    "qf", "help", "man", "notify", "lspinfo", "spectre_panel",
    "startuptime", "tsplayground", "PlenaryTestPopup", "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Wrap and spellcheck in text filetypes
augroup("TextFileSettings", { clear = true })
autocmd("FileType", {
  group = "TextFileSettings",
  pattern = { "gitcommit", "markdown", "text", "plaintex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto-create parent directories on save
augroup("AutoMkdir", { clear = true })
autocmd("BufWritePre", {
  group = "AutoMkdir",
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Remove trailing whitespace on save
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Filetype-specific indentation
augroup("FileTypeIndent", { clear = true })
autocmd("FileType", {
  group = "FileTypeIndent",
  pattern = { "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})
autocmd("FileType", {
  group = "FileTypeIndent",
  pattern = { "ruby", "lua", "javascript", "typescript", "html", "css", "json", "yaml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
