#!/usr/bin/env bash
# =============================================================================
# Neovim-Only Install — for machines that already have a dev environment
# =============================================================================
# This script ONLY sets up Neovim config. It does NOT install Homebrew packages,
# language runtimes, tmux, zsh config, Ghostty, or macOS defaults.
#
# Prerequisites:
#   - Neovim 0.11+ (check with: nvim --version)
#   - git, curl (for lazy.nvim bootstrap and plugin cloning)
#   - A C compiler (gcc/clang) for treesitter parser compilation
#   - ripgrep (rg) — used by Telescope live grep
#   - fd — used by Telescope file finder
#   - Node.js — required by some LSP servers (ts_ls, etc.)
#
# Optional (enhanced experience):
#   - git-delta — better git diffs in Neovim
#   - lazygit — terminal git UI (launched via <leader>tg)
#
# Usage:
#   git clone <repo> ~/dotfiles && cd ~/dotfiles && ./install-nvim.sh
#
# What it does:
#   1. Backs up your existing ~/.config/nvim (if any)
#   2. Symlinks this repo's nvim/ dir to ~/.config/nvim
#   3. Runs lazy.nvim headless sync (installs all plugins)
#   4. Tells you what to do next
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Helpers ----------------------------------------------------------------
info()  { printf "\033[1;34m▸ %s\033[0m\n" "$*"; }
ok()    { printf "\033[1;32m✔ %s\033[0m\n" "$*"; }
warn()  { printf "\033[1;33m⚠ %s\033[0m\n" "$*"; }
fail()  { printf "\033[1;31m✖ %s\033[0m\n" "$*"; exit 1; }
skip()  { printf "\033[0;90m  ⏭ %s (already done)\033[0m\n" "$*"; }

command_exists() { command -v "$1" &>/dev/null; }

# --- Pre-flight checks ------------------------------------------------------
echo ""
info "Neovim-Only Installer"
echo ""

# Check Neovim
if ! command_exists nvim; then
  fail "Neovim not found. Install Neovim 0.11+ first:
    macOS:  brew install neovim
    Ubuntu: sudo add-apt-repository ppa:neovim-ppa/unstable && sudo apt install neovim
    Arch:   sudo pacman -S neovim
    Other:  https://github.com/neovim/neovim/releases"
fi

NVIM_VERSION=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
if [[ "$NVIM_MAJOR" -lt 1 ]] && [[ "$NVIM_MINOR" -lt 11 ]]; then
  warn "Neovim $NVIM_VERSION detected. This config requires 0.11+."
  warn "Some features (vim.lsp.config, treesitter main branch) may not work."
  echo ""
  read -rp "Continue anyway? [y/N] " answer
  [[ "$answer" =~ ^[Yy] ]] || exit 0
fi

ok "Neovim $NVIM_VERSION"

# Check git
command_exists git || fail "git not found. Install git first."
ok "git"

# Check recommended tools
for tool in rg fd cc; do
  if command_exists "$tool"; then
    ok "$tool"
  else
    case "$tool" in
      rg) warn "ripgrep (rg) not found — Telescope live grep won't work. Install: brew install ripgrep / apt install ripgrep" ;;
      fd) warn "fd not found — Telescope file finder may be slower. Install: brew install fd / apt install fd-find" ;;
      cc) warn "C compiler not found — treesitter parsers won't compile. Install Xcode CLI tools or build-essential." ;;
    esac
  fi
done

# Check optional tools
for tool in delta lazygit node; do
  if command_exists "$tool"; then
    ok "$tool (optional)"
  else
    case "$tool" in
      delta)   info "git-delta not installed (optional — better diffs)" ;;
      lazygit) info "lazygit not installed (optional — <leader>tg won't work)" ;;
      node)    warn "Node.js not found — some LSP servers (ts_ls, eslint) require it" ;;
    esac
  fi
done

echo ""

# --- Symlink Neovim config --------------------------------------------------
NVIM_CONFIG="$HOME/.config/nvim"

if [[ -L "$NVIM_CONFIG" ]] && [[ "$(readlink "$NVIM_CONFIG")" == "$DOTFILES_DIR/nvim" ]]; then
  skip "Neovim config symlink"
else
  if [[ -e "$NVIM_CONFIG" ]] || [[ -L "$NVIM_CONFIG" ]]; then
    BACKUP="${NVIM_CONFIG}.backup.$(date +%s)"
    info "Backing up existing config: $NVIM_CONFIG → $BACKUP"
    mv "$NVIM_CONFIG" "$BACKUP"
    ok "Backup created"
  fi
  mkdir -p "$(dirname "$NVIM_CONFIG")"
  ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG"
  ok "Symlinked $NVIM_CONFIG → $DOTFILES_DIR/nvim"
fi

# --- Clean old lazy.nvim state if this is a fresh install --------------------
# lazy.nvim will bootstrap itself on first run from init.lua

# --- Headless plugin sync ---------------------------------------------------
info "Syncing Neovim plugins (headless — this may take a minute on first run)…"
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
ok "Neovim plugins synced"

# --- Done -------------------------------------------------------------------
echo ""
ok "Neovim setup complete!"
echo ""
info "Next steps:"
info "  1. Open nvim"
info "  2. Run :checkhealth to verify everything"
info "  3. Run :Mason to see/install language servers"
info "  4. Run :Copilot auth to set up GitHub Copilot (if you use it)"
info "  5. Press Space then ? to open the cheat sheet"
echo ""
info "For the full setup (tmux, zsh, brew packages, etc.), run ./install.sh instead."
echo ""
