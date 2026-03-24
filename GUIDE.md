# Matei's Dev Setup — Complete Reference Guide

> Ghostty + Zsh + Neovim + Tmux + Claude Code | Theme: Catppuccin Mocha everywhere

---

## 1. What's Installed

### Terminal: Ghostty

GPU-accelerated terminal built by Mitchell Hashimoto (HashiCorp founder) using Zig and native Metal rendering on macOS. Config at `~/.config/ghostty/config`. Uses JetBrains Mono Nerd Font 14pt, Catppuccin Mocha colors.

| Keys | Action |
|------|--------|
| `Cmd+D` | Split pane right |
| `Cmd+Shift+D` | Split pane down |
| `Cmd+T` | New tab |
| `Cmd+W` | Close pane |
| `Cmd+=` / `Cmd+-` | Increase / decrease font size |
| `Cmd+0` | Reset font size |

---

### Shell: Zsh

Config is split across three files:

- **`~/.zshenv`** — universal env vars (GOPATH, EDITOR, XDG dirs). Loaded for every zsh session.
- **`~/.zprofile`** — PATH construction. Login shells only. Sets up Homebrew, Go, Cargo, pyenv, rbenv, and GNU coreutils.
- **`~/.zshrc`** — interactive config. Completions, vi-mode, history, plugins, aliases, functions.

#### Shell Integrations

- **Atuin** — replaces `Ctrl+R` with a full-text SQLite-backed history search UI. Run `atuin register` to sync across machines.
- **Zoxide** — smarter `cd`. Type `z project-name` to jump to frequently-visited directories.
- **FZF** — fuzzy finder. `Ctrl+T` for files, `Alt+C` for directories. Preview shows bat-highlighted content.
- **direnv** — per-directory environment variables. Create a `.envrc` file and direnv auto-loads it when you cd in.
- **Starship** — cross-shell prompt showing git branch, language versions, k8s context, command duration. Config at `~/.config/starship.toml`.
- **NVM** — lazy-loaded for fast shell startup. First call to `node`/`npm`/`nvm` triggers the load.

#### Key Aliases

| Alias | Expands To | What It Does |
|-------|-----------|--------------|
| `ls` | `eza --icons` | List files with icons and colors |
| `ll` | `eza -la --git` | Detailed listing with git status |
| `lt` | `eza --tree` | Tree view (3 levels deep) |
| `lsd` | `lsd` | Alternate listing with LSD |
| `cat` | `bat` | Syntax-highlighted file viewer |
| `grep` | `rg` | Ripgrep (fast recursive search) |
| `find` | `fd` | Modern find replacement |
| `du` | `dust` | Disk usage tree view |
| `v` / `vim` | `nvim` | Neovim |
| `lg` | `lazygit` | Terminal UI for git |
| `g` | `git` | Git shorthand |
| `gs` | `git status -sb` | Short git status |
| `d` | `docker` | Docker shorthand |
| `dc` | `docker compose` | Docker compose shorthand |
| `k` | `kubectl` | Kubernetes shorthand |
| `tf` | `terraform` | Terraform shorthand |

#### Shell Functions

| Function | What It Does |
|----------|-------------|
| `mkcd <dir>` | Create directory and cd into it |
| `gclone <url>` | Git clone and cd into the repo |
| `proj` | FZF project switcher (searches ~/code, ~/go/src, ~/work) |
| `dsh` | FZF-pick a running Docker container and shell into it |
| `killport <port>` | Kill whatever process is listening on that port |

---

## 2. Neovim

Modular configuration following TJ DeVries' patterns. Uses lazy.nvim for plugin management with per-plugin files in `lua/matei/plugins/`. Leader key is `Space`, local leader is `,`. Theme is Catppuccin Mocha. Requires **Neovim 0.11+**.

### Core Navigation

| Keys | Action |
|------|--------|
| `jk` or `kj` | Exit insert mode (instead of Esc) |
| `Ctrl+d` / `Ctrl+u` | Half-page down/up (cursor stays centered) |
| `n` / `N` | Next/prev search result (centered) |
| `Ctrl+h/j/k/l` | Navigate between splits (tmux-aware — no prefix needed) |
| `Shift+H` / `Shift+L` | Previous / next buffer |
| `<leader>bd` | Close current buffer |
| `<leader>bD` | Close all buffers |
| `Alt+j` / `Alt+k` | Move current line down/up |
| `<` / `>` (visual) | Indent left/right (keeps selection) |
| `s` | Flash jump (type 2 chars to jump anywhere) |
| `S` | Flash Treesitter (select by syntax node) |

### Finding Things (Telescope)

All fuzzy-finding is handled by Telescope (master branch) with FZF-native sorting. Every picker supports `Ctrl+J/K` to navigate, `Ctrl+Q` to send to quickfix, `Ctrl+S` for horizontal split.

| Keys | Action |
|------|--------|
| `<leader>ff` | Find files (hidden files included) |
| `<leader>fg` | Live grep across project |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fw` | Grep word under cursor |
| `<leader>fd` | Diagnostics (all files) |
| `<leader>fs` | Document symbols (LSP) |
| `<leader>fS` | Workspace symbols (LSP) |
| `<leader>fk` | Search all keymaps |
| `<leader>fc` | Search commands |
| `<leader>fm` | Search marks |
| `<leader>ft` | Browse color schemes |
| `<leader>fe` | File browser (current directory) |
| `<leader>/` | Fuzzy search in current buffer |

### File Explorer & Fast Switching

| Keys | Action |
|------|--------|
| `<leader>n` | Toggle Neo-tree file explorer |
| `<leader>N` | Reveal current file in Neo-tree |
| `<leader>a` | Add current file to Harpoon |
| `Ctrl+E` | Open Harpoon quick menu |
| `<leader>1`–`5` | Jump to Harpoon file 1–5 |

In Neo-tree: `l` opens, `h` closes a node. Hidden files and gitignored files are visible by default.

### LSP & Code Intelligence

Mason v2 auto-installs language servers. Server config uses the new `vim.lsp.config()` API (Neovim 0.11+) with `automatic_enable` via mason-lspconfig. Servers: Go (gopls), Ruby (ruby_lsp, solargraph), TypeScript/JavaScript (ts_ls), Python (pyright), Rust (rust_analyzer), Terraform (terraformls, tflint), HTML/CSS/Tailwind, JSON, YAML, Docker, Bash.

| Keys | Action |
|------|--------|
| `gd` | Go to definition (via Telescope) |
| `gr` | Find all references (via Telescope) |
| `gI` | Go to implementation (via Telescope) |
| `gD` | Go to declaration |
| `gy` | Go to type definition (via Telescope) |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format buffer (async) |
| `<leader>cs` | Signature help |
| `<leader>ch` | Toggle inlay hints |
| `<leader>cl` | Run code lens |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>e` | Float diagnostic message |

### Completion (nvim-cmp)

Completion sources: LSP, snippets (LuaSnip + friendly-snippets), buffer text, file paths, Neovim Lua API. Ghost text preview is enabled.

| Keys | Action |
|------|--------|
| `Ctrl+N` / `Ctrl+P` | Next / previous completion item |
| `Ctrl+Y` | Confirm selection (TJ's preferred key) |
| `Enter` | Confirm (only if explicitly selected) |
| `Ctrl+Space` | Trigger completion manually |
| `Ctrl+E` | Abort/dismiss completion menu |
| `Tab` / `Shift+Tab` | Jump to next/prev snippet placeholder |
| `Ctrl+B` / `Ctrl+F` | Scroll docs up/down |

### Formatting & Linting

Format-on-save is enabled globally via conform.nvim. Linting runs on save and insert-leave via nvim-lint.

| Language | Formatter | Linter |
|----------|-----------|--------|
| Go | goimports + gofumpt | golangci-lint |
| Ruby | rubocop | rubocop |
| JS/TS/CSS/HTML | prettier | eslint_d |
| Python | ruff_format + ruff_fix | ruff |
| Lua | stylua | — |
| Terraform | terraform_fmt | tflint |
| Shell/Bash | shfmt | shellcheck |
| Dockerfile | — | hadolint |
| YAML | — | yamllint |
| Rust | rustfmt | — |
| SQL | sql_formatter | — |

### Git Integration

Gitsigns provides inline blame, hunk staging, and diff preview. Fugitive wraps git commands. Diffview provides a full diff UI.

| Keys | Action |
|------|--------|
| `]h` / `[h` | Next / previous git hunk |
| `<leader>hs` | Stage hunk (also works in visual mode) |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk inline |
| `<leader>hb` | Full blame for current line |
| `<leader>hd` | Diff this file |
| `<leader>hD` | Diff against HEAD~ |
| `<leader>htb` | Toggle inline line blame |
| `<leader>htd` | Toggle deleted hunks |
| `<leader>gg` | Open Git status (Fugitive) |
| `<leader>gd` | Open Diffview |
| `<leader>gh` | File history (current file) |
| `<leader>gH` | Full branch history |
| `<leader>gc` | Browse git commits (Telescope) |
| `<leader>gb` | Browse git branches (Telescope) |
| `<leader>gS` | Browse git status (Telescope) |
| `<leader>tg` | Open Lazygit (floating terminal) |

### Go Development

Enhanced Go support via go.nvim on top of gopls. Gopls is configured with gofumpt, static analysis (nilness, unusedparams, shadow), and all code lenses enabled.

| Keys | Action |
|------|--------|
| `<leader>cgt` | Run Go tests |
| `<leader>cgT` | Run test for current function |
| `<leader>cgr` | Go run |
| `<leader>cge` | Insert `if err != nil` block |
| `<leader>cga` | Add struct tags (json) |
| `<leader>cgA` | Remove struct tags |
| `<leader>cgc` | Toggle test coverage overlay |
| `<leader>cgi` | Implement interface |
| `<leader>cgf` | Fill struct fields |

### AI / LLM Development

Four LLM integrations with different use cases:

- **Copilot** — inline suggestions as you type. Auto-triggers in insert mode.
- **CopilotChat** — chat sidebar for explaining, reviewing, fixing, optimizing, generating tests/docs. Configured to use Claude Sonnet.
- **Claude Code** — full agentic terminal for complex multi-file tasks.
- **CodeCompanion** — multi-provider LLM chat (Claude, GPT, etc.) with inline code actions.

| Keys | Action |
|------|--------|
| `Alt+L` | Accept Copilot suggestion |
| `Alt+W` | Accept Copilot word |
| `Alt+J` | Accept Copilot line |
| `Alt+]` / `Alt+[` | Next / previous Copilot suggestion |
| `Ctrl+]` | Dismiss Copilot suggestion |
| `<leader>ll` | Open Claude Code (floating terminal) |
| `<leader>lc` | Open Copilot Chat sidebar |
| `<leader>le` | Explain selected code |
| `<leader>lr` | Review selected code |
| `<leader>lf` | Fix selected code |
| `<leader>lo` | Optimize selected code |
| `<leader>lt` | Generate tests for selection |
| `<leader>ld` | Generate docs for selection |
| `<leader>la` | CodeCompanion actions menu |
| `<leader>lh` | Toggle CodeCompanion chat |
| `ga` (visual) | Add selection to CodeCompanion chat |

### Debugging (DAP)

Debug Adapter Protocol with nvim-dap. Mason auto-installs adapters for Go (Delve), Node, and Python.

| Keys | Action |
|------|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompts for condition) |
| `<leader>dc` | Continue / start debugging |
| `<leader>dC` | Run to cursor |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dp` | Pause |
| `<leader>dt` | Terminate session |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Evaluate expression (works in visual mode) |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session picker |
| `<leader>dw` | Widgets (hover) |

### Testing (Neotest)

Run tests for Go, Ruby (RSpec), JavaScript (Jest), Python, and Rust directly from Neovim.

| Keys | Action |
|------|--------|
| `<leader>Tt` | Run nearest test |
| `<leader>Tf` | Run all tests in file |
| `<leader>Ta` | Run all tests in project |
| `<leader>Ts` | Toggle test summary panel |
| `<leader>To` | Show test output |
| `<leader>TO` | Toggle output panel |
| `<leader>Td` | Debug nearest test |
| `]T` / `[T` | Jump to next/prev failed test |

### Editing Conveniences

| Keys | Action |
|------|--------|
| `gcc` | Toggle comment for current line |
| `gc` (visual) | Toggle comment for selection |
| `gsa<char>` | Add surround (e.g., `gsa"` adds quotes) |
| `gsd<char>` | Delete surround |
| `gsr<old><new>` | Replace surround |
| `gsf` / `gsF` | Find surround forward / backward |
| `gsh` | Highlight surround |
| `Y` | Yank to end of line (matches D and C) |
| `<leader>p` (visual) | Paste without losing register |
| `<leader>d` | Delete without yanking |
| `<leader>sr` | Open Spectre (search & replace across project) |
| `<leader>w` | Save file |
| `<leader>W` | Save all files |
| `<leader>q` | Quit |
| `<leader>Q` | Force quit |
| `Ctrl+A` | Select all |

### Text Objects (Treesitter)

Enhanced text objects that understand code structure. Uses the new nvim-treesitter main branch (2025 rewrite) with separate textobjects plugin.

| Keys | Action |
|------|--------|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside argument/parameter |
| `ai` / `ii` | Around / inside conditional |
| `al` / `il` | Around / inside loop |
| `ab` / `ib` | Around / inside block |
| `]f` / `[f` | Jump to next / previous function start |
| `]F` / `[F` | Jump to next / previous function end |
| `]c` / `[c` | Jump to next / previous class start |
| `]C` / `[C` | Jump to next / previous class end |
| `]a` / `[a` | Jump to next / previous argument |
| `Ctrl+Space` | Start incremental selection, then expand |
| `Backspace` | Shrink incremental selection |
| `<leader>sa` | Swap parameter with next |
| `<leader>sA` | Swap parameter with previous |
| `;` / `,` | Repeat last textobject move (also works with f/t/F/T) |

### Diagnostics & Trouble

| Keys | Action |
|------|--------|
| `<leader>xx` | Toggle diagnostics list (all files) |
| `<leader>xX` | Toggle diagnostics (current buffer only) |
| `<leader>xL` | Location list |
| `<leader>xQ` | Quickfix list |
| `<leader>xt` | Todo comments (in Trouble) |
| `<leader>xT` | Todo comments (in Telescope) |
| `]t` / `[t` | Jump to next / previous TODO comment |
| `[q` / `]q` | Previous / next quickfix item |
| `[l` / `]l` | Previous / next location list item |

### Terminals

| Keys | Action |
|------|--------|
| `Ctrl+\` | Toggle floating terminal |
| `<leader>tf` | Float terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal |
| `Esc Esc` | Exit terminal mode back to normal |

### Sessions & Tabs

| Keys | Action |
|------|--------|
| `<leader>qs` | Restore session for current directory |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Stop session persistence |
| `<leader><tab>n` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>l` | Last tab |
| `<leader><tab>f` | First tab |
| `Ctrl+Up/Down` | Resize split height |
| `Ctrl+Left/Right` | Resize split width |

> **Tip:** Press `<leader>` and wait — Which-key will show all available continuations. Press `<leader>fk` to search all keymaps. Press `<leader>?` to open the cheat sheet.

---

## 3. Tmux

Prefix is `Ctrl+A` (not the default Ctrl+B). Vi copy-mode, mouse enabled, windows/panes start at 1. Catppuccin-styled top status bar with session name, window tabs, and clock.

### Pane Management

| Keys | Action |
|------|--------|
| `prefix + \|` | Split vertically (side by side) |
| `prefix + -` | Split horizontally (top/bottom) |
| `Ctrl+h/j/k/l` | Navigate panes (seamless with Neovim — no prefix needed) |
| `prefix + H/J/K/L` | Resize panes (5 units, repeatable) |
| `prefix + c` | New window (inherits current directory) |

### Sessions & Windows

| Keys | Action |
|------|--------|
| `prefix + S` | Create new session (prompts for name) |
| `prefix + K` | Kill current session (with confirmation) |
| `prefix + BTab` | Switch to last session |
| `prefix + o` | SessionX picker (FZF + zoxide-aware) |
| `prefix + r` | Reload tmux config |

### Copy Mode (Vi-style)

| Keys | Action |
|------|--------|
| `prefix + [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `Ctrl+V` | Toggle rectangle/block selection |
| `y` | Copy selection to system clipboard |
| `Escape` | Cancel copy mode |

### Popup Tools

Tmux 3.2+ popups provide floating windows for common tools:

| Keys | Action |
|------|--------|
| `prefix + g` | Lazygit (85% of screen) |
| `prefix + G` | GitHub CLI dashboard |
| `prefix + C` | Claude Code (85% of screen) |

### Session Persistence

tmux-resurrect + tmux-continuum auto-save your session every 10 minutes and restore on tmux start. Your windows, panes, and even Neovim sessions survive reboots. Install plugins on first launch with `prefix + I` (capital I).

---

## 4. Putting It Together

### Typical Workflow

1. Open Ghostty. Tmux auto-attaches to your last session (or creates a new one).
2. Navigate to your project: `z myproject` (zoxide remembers your directories).
3. Open Neovim: `v`. If you had a session here before, `<leader>qs` restores it.
4. Find files with `<leader>ff`, grep with `<leader>fg`, pin important files with `<leader>a` (Harpoon).
5. Code with Copilot inline, use `<leader>ll` for Claude Code on complex tasks.
6. Stage hunks with `<leader>hs`, or open Lazygit with `<leader>tg` (Neovim) or `prefix+g` (tmux).
7. Run tests with `<leader>Tt`, debug with `<leader>dc`.
8. `Ctrl+h/j/k/l` moves between Neovim splits and tmux panes seamlessly — no prefix needed.

### Secrets & API Keys

Put sensitive values in `~/.zshrc.local` (not tracked by git):

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
```

Then run `:Copilot auth` in Neovim and `atuin login` in the terminal.

### Post-Install Checklist

- [ ] Open Ghostty
- [ ] In tmux: `prefix + I` to install TPM plugins
- [ ] In Neovim: `:checkhealth` to verify everything is configured
- [ ] In Neovim: `:Copilot auth` to authenticate GitHub Copilot
- [ ] In Neovim: `:Mason` to verify language servers are installed
- [ ] In terminal: `atuin register` or `atuin login` for shell history sync
- [ ] Install JetBrains IDEs via JetBrains Toolbox app
- [ ] Uncomment SSH rewrite in `~/.gitconfig` after setting up your SSH key
- [ ] Install Antigravity IDE via `brew install --cask antigravity`

---

## 5. Architecture & Technical Details

### Plugin Infrastructure (Neovim 0.11+ / 2025)

This setup uses the latest APIs from the Neovim ecosystem:

- **Mason v2** (`mason-org/`) — `setup_handlers()` is gone. Servers are configured via `vim.lsp.config()` and auto-enabled via `vim.lsp.enable()`.
- **nvim-treesitter main branch** — complete rewrite. No more `require("nvim-treesitter.configs").setup()`. Parsers installed via `require("nvim-treesitter").install()`, highlighting via `vim.treesitter.start()` autocmd.
- **Telescope master branch** — compatible with the new treesitter; the `0.1.x` branch used the removed `ft_to_lang` API.
- **LspAttach autocmd** — LSP keymaps are set via a global `LspAttach` autocmd rather than per-server `on_attach` callbacks.

### Complete Software Inventory

**Languages & Runtimes:** Go (brew), Ruby (rbenv), Node.js (nvm, lazy-loaded), Python (pyenv), Rust (rustup), Lua, LuaJIT.

**Infrastructure & DevOps:** Terraform, Packer, Vault (HashiCorp tap), AWS CLI, Azure CLI, kubectl, kubectx, helm, kustomize, k9s, stern, terraform-docs, tflint, checkov, trivy.

**Databases:** PostgreSQL 16, MySQL client, Redis, SQLite, MongoDB Shell (mongosh).

**Containers:** Docker CLI + Docker Compose + Docker Desktop. Colima + Lima as lightweight alternative.

**GUI Applications:** Ghostty, VS Code, Antigravity IDE, JetBrains Toolbox, Google Chrome, Firefox, Arc, Docker Desktop, Postman, TablePlus, Fork, Charles, ngrok, Slack, Discord, Zoom, Linear, Raycast, 1Password, Notion, Obsidian, Rectangle, Karabiner-Elements, Contexts, Figma, The Unarchiver, AppCleaner, Stats, AlDente, IINA.

**Fonts:** JetBrains Mono Nerd Font, Fira Code Nerd Font, Hack Nerd Font, Meslo LG Nerd Font, CaskaydiaCove Nerd Font, Inter.

### Treesitter Parsers (27)

Core: lua, vim, vimdoc, query, regex, markdown, markdown_inline. Web: html, css, javascript, typescript, tsx, json. Backend: go, gomod, gosum, gowork, ruby, python, rust. Infra: terraform, hcl, dockerfile, yaml, toml, bash. Data: sql, graphql. Config: gitcommit, gitignore, git_rebase, diff, make, cmake, proto.
