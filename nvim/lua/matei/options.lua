-- =============================================================================
-- Options — vim.opt settings
-- =============================================================================
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.showmode = false          -- shown in statusline
opt.pumheight = 12            -- popup menu height
opt.pumblend = 10             -- popup transparency
opt.winblend = 10             -- floating window transparency
opt.cmdheight = 1
opt.laststatus = 3            -- global statusline
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.colorcolumn = "100"
opt.fillchars = { eob = " ", fold = " ", diff = "╱" }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Files
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true

-- Performance
opt.updatetime = 200
opt.timeoutlen = 300
opt.redrawtime = 1500
opt.lazyredraw = false

-- Mouse
opt.mouse = "a"
opt.mousemoveevent = true

-- Clipboard (system)
opt.clipboard = "unnamedplus"

-- Folding (treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- Grep
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Spelling
opt.spelllang = "en_us"

-- Session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
