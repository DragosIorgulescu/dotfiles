# Matei's Dotfiles

Automated MacBook setup for fullstack development (Go, Ruby, Node, Terraform, and more).

## What's Included

**Terminal:** Ghostty (GPU-accelerated, native Metal on macOS, by Mitchell Hashimoto)
**Shell:** Zsh with Starship prompt, vi-mode, lazy-loaded nvm, fzf, zoxide, atuin
**Editor:** Neovim 0.11+ (TJ DeVries-style modular config with lazy.nvim)
**Multiplexer:** Tmux with vim-tmux-navigator, session persistence, lazygit popup
**LLM Dev:** Claude Code (brew cask), Copilot, CodeCompanion (multi-provider), Claude terminal integration

## Quick Start

### Full Setup (new Mac)

```bash
# 1. Clone
git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run (idempotent — safe to re-run if interrupted)
chmod +x install.sh
./install.sh

# 3. Post-install
# - Open Ghostty
# - In tmux: prefix + I (install TPM plugins)
# - In Neovim: :checkhealth
# - In Neovim: :Mason (verify servers installed)
# - In Neovim: :Copilot auth
# - Install JetBrains IDEs via Toolbox app
```

### Lightweight Setup (existing Mac)

If you already have a dev environment and want configs without installing brew packages:

```bash
git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install-light.sh
```

This symlinks Zsh, Neovim, Starship, Tmux (with TPM), and Ghostty configs. Git config is opt-in (it overwrites `user.name`/`user.email`). No Homebrew, no language runtimes, no macOS defaults. Backs up any existing configs.

### Neovim Only (existing machine)

If you just want the Neovim config:

```bash
git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install-nvim.sh
```

This only symlinks `nvim/` to `~/.config/nvim` and syncs plugins. It checks for prerequisites (Neovim 0.11+, ripgrep, fd, a C compiler) and warns about anything missing. Your existing zsh, tmux, git, and brew setup are untouched. Works on macOS and Linux.

## Structure

```
dotfiles/
├── install.sh              # Full bootstrap script (idempotent)
├── install-light.sh        # Lightweight install (symlinks only, no brew)
├── install-nvim.sh         # Neovim-only install (for existing machines)
├── Brewfile                # Homebrew packages & casks
├── .gitconfig              # Git configuration (delta pager w/ fallback)
├── .gitignore_global       # Global gitignore
├── starship.toml           # Prompt configuration
├── GUIDE.md                # Complete keybinding reference
├── USAGE.md                # How to use & maintain this setup
├── ghostty/
│   └── config              # Ghostty terminal config
├── zsh/
│   ├── .zshenv             # Env vars (all sessions)
│   ├── .zprofile           # PATH (login sessions)
│   └── .zshrc              # Interactive shell config
├── tmux/
│   └── tmux.conf           # Tmux config (prefix: C-a)
├── nvim/
│   ├── init.lua            # Bootstrap lazy.nvim
│   └── lua/matei/
│       ├── options.lua     # Vim options
│       ├── keymaps.lua     # Key mappings
│       ├── autocmds.lua    # Autocommands
│       └── plugins/
│           ├── colorscheme.lua  # Catppuccin Mocha
│           ├── telescope.lua    # Fuzzy finder (master branch)
│           ├── treesitter.lua   # Syntax & text objects (main branch, 2025 rewrite)
│           ├── lsp.lua          # LSP (Mason v2 + vim.lsp.config API)
│           ├── completion.lua   # nvim-cmp + snippets
│           ├── formatting.lua   # conform.nvim + nvim-lint
│           ├── git.lua          # gitsigns, fugitive, diffview
│           ├── ui.lua           # statusline, bufferline, which-key
│           ├── editor.lua       # neo-tree, harpoon, flash, surround
│           ├── terminal.lua     # toggleterm, tmux-navigator
│           ├── llm.lua          # Copilot, Claude Code, CodeCompanion
│           ├── go.lua           # Go development (go.nvim)
│           ├── dap.lua          # Debug Adapter Protocol
│           ├── testing.lua      # Neotest (Go, Ruby, JS, Python, Rust)
│           └── cheatsheet.lua   # In-editor cheat sheet (<leader>?)
└── scripts/
    └── macos-defaults.sh   # macOS system preferences
```

## Key Bindings (Quick Reference)

### Neovim (Leader = Space)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>/` | Fuzzy search in buffer |
| `<leader>n` | Toggle file explorer |
| `<leader>a` | Harpoon add file |
| `<C-e>` | Harpoon menu |
| `<leader>1-5` | Jump to harpoon file |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>ll` | Claude Code (floating terminal) |
| `<leader>lc` | Copilot Chat |
| `<leader>la` | LLM actions (CodeCompanion) |
| `<leader>tg` | Lazygit |
| `<C-\>` | Toggle terminal |
| `<leader>?` | Open cheat sheet |

### Tmux (Prefix = Ctrl-a)

| Key | Action |
|-----|--------|
| `prefix + \|` | Vertical split |
| `prefix + -` | Horizontal split |
| `prefix + g` | Lazygit popup |
| `prefix + C` | Claude Code popup |
| `prefix + o` | Session picker (sessionx) |
| `prefix + r` | Reload config |
| `C-h/j/k/l` | Navigate panes (vim-aware) |

## Language Servers (auto-installed via Mason v2)

gopls, ruby_lsp, solargraph, ts_ls, lua_ls, pyright, rust_analyzer,
terraformls, tflint, html, cssls, tailwindcss, eslint, jsonls, yamlls,
dockerls, docker_compose_language_service, bashls

## Requirements

- macOS (Apple Silicon or Intel)
- Neovim 0.11+ (installed via Homebrew)
- Tmux 3.2+ (for popup support)
- Git, curl (pre-installed on macOS)

## Post-Install Notes

- **Docker:** The Brewfile includes both `colima` (lightweight) and Docker Desktop. Use one or the other.
- **JetBrains:** Install specific IDEs (GoLand, RubyMine, WebStorm) via JetBrains Toolbox.
- **Claude Code:** Installed via `brew install --cask claude-code`. Requires `ANTHROPIC_API_KEY` env var in `~/.zshrc.local`.
- **Copilot:** Run `:Copilot auth` in Neovim to authenticate.
- **CodeCompanion:** Set `ANTHROPIC_API_KEY` for Claude integration.
- **Secrets:** Put API keys in `~/.zshrc.local` (not tracked by git).
- **SSH:** Uncomment the SSH rewrite in `~/.gitconfig` after setting up your SSH key.

## Manual Configuration (not in git)

The following files are gitignored because they contain machine-specific or sensitive data. You need to set them up manually:

**`~/.zshrc.local`** — local shell overrides and API keys (sourced at end of `.zshrc`):

```bash
# Create this file on each machine:
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export OPENAI_API_KEY="sk-..."

# Machine-specific overrides go here too
# export PATH="/some/local/path:$PATH"
```

**`.gitconfig` user section** — the repo ships with my name/email. If you fork this, update `[user]` in `.gitconfig`:

```ini
[user]
    name = Your Name
    email = your@email.com
```

**SSH rewrite** — commented out by default in `.gitconfig`. After setting up your SSH key:

```bash
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

## Documentation

- **[GUIDE.md](GUIDE.md)** — Complete keybinding reference for every tool
- **[USAGE.md](USAGE.md)** — How to use Neovim/Tmux, maintenance, troubleshooting
