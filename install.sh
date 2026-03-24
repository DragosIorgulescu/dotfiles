#!/usr/bin/env bash
# =============================================================================
# Matei's MacBook Dev Setup — Bootstrap Script
# =============================================================================
# Fully idempotent: safe to re-run at any time. Skips what's already done.
#
# Usage: git clone <repo> ~/dotfiles && cd ~/dotfiles && ./install.sh
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$DOTFILES_DIR/install.log"

# --- Helpers ----------------------------------------------------------------
info()  { printf "\033[1;34m▸ %s\033[0m\n" "$*"; }
ok()    { printf "\033[1;32m✔ %s\033[0m\n" "$*"; }
warn()  { printf "\033[1;33m⚠ %s\033[0m\n" "$*"; }
fail()  { printf "\033[1;31m✖ %s\033[0m\n" "$*"; exit 1; }
skip()  { printf "\033[0;90m  ⏭ %s (already done)\033[0m\n" "$*"; }

command_exists() { command -v "$1" &>/dev/null; }

# --- Pre-flight -------------------------------------------------------------
[[ "$(uname)" == "Darwin" ]] || fail "This script is for macOS only."

info "Logging to $LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

# --- Xcode CLI Tools -------------------------------------------------------
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools…"
  xcode-select --install
  echo "Press Enter after Xcode CLI Tools finish installing…"
  read -r
  ok "Xcode CLI Tools"
else
  skip "Xcode CLI Tools"
fi

# --- Homebrew ---------------------------------------------------------------
if ! command_exists brew; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ok "Homebrew"
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
  skip "Homebrew"
fi

# --- Brewfile (taps, formulae, casks) ---------------------------------------
info "Installing packages via Homebrew Bundle (skips already-installed)…"
if ! brew bundle --file="$DOTFILES_DIR/Brewfile" --verbose 2>&1; then
  warn "Some Brewfile dependencies failed. Checking which ones…"
  brew bundle check --file="$DOTFILES_DIR/Brewfile" --verbose 2>&1 || true
  warn "Continuing with the rest of the setup. Fix failed packages manually later."
else
  ok "Homebrew packages"
fi

# --- Language Version Managers ----------------------------------------------

# Go (installed via brew, but set GOPATH)
info "Setting up Go workspace…"
mkdir -p "$HOME/go/bin" "$HOME/go/src" "$HOME/go/pkg"
ok "Go workspace"

# Ruby via rbenv
if command_exists rbenv; then
  LATEST_RUBY=$(rbenv install -l 2>/dev/null | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
  if [[ -n "$LATEST_RUBY" ]]; then
    if rbenv versions --bare 2>/dev/null | grep -qF "$LATEST_RUBY"; then
      skip "Ruby $LATEST_RUBY"
    else
      info "Installing Ruby $LATEST_RUBY via rbenv…"
      rbenv install -s "$LATEST_RUBY"
      rbenv global "$LATEST_RUBY"
      ok "Ruby $LATEST_RUBY"
    fi
  fi
fi

# Node via nvm
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR" ]] || [[ -d "$(brew --prefix nvm 2>/dev/null)" ]]; then
  # shellcheck disable=SC1091
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
  if nvm ls --no-colors 2>/dev/null | grep -q "lts/"; then
    skip "Node LTS"
  else
    info "Installing latest LTS Node via nvm…"
    nvm install --lts
    nvm alias default lts/*
    ok "Node LTS"
  fi
fi

# Python via pyenv
if command_exists pyenv; then
  LATEST_PY=$(pyenv install -l 2>/dev/null | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
  if [[ -n "$LATEST_PY" ]]; then
    if pyenv versions --bare 2>/dev/null | grep -qF "$LATEST_PY"; then
      skip "Python $LATEST_PY"
    else
      info "Installing Python $LATEST_PY via pyenv…"
      pyenv install -s "$LATEST_PY"
      pyenv global "$LATEST_PY"
      ok "Python $LATEST_PY"
    fi
  fi
fi

# Rust
if command_exists rustup; then
  skip "Rust"
else
  info "Installing Rust via rustup…"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
  ok "Rust"
fi

# --- Symlinks (idempotent: only backs up if target isn't already correct) ---
info "Creating symlinks…"

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  # If the symlink already points to the right place, skip
  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    skip "  $dst"
    return
  fi
  # Back up any existing file/symlink that isn't ours
  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%s)"
    mv "$dst" "$backup"
    warn "  Backed up $dst → $backup"
  fi
  ln -sf "$src" "$dst"
  ok "  $dst → $src"
}

# Zsh
symlink "$DOTFILES_DIR/zsh/.zshrc"           "$HOME/.zshrc"
symlink "$DOTFILES_DIR/zsh/.zshenv"          "$HOME/.zshenv"
symlink "$DOTFILES_DIR/zsh/.zprofile"        "$HOME/.zprofile"

# Neovim
symlink "$DOTFILES_DIR/nvim"                 "$HOME/.config/nvim"

# Tmux
symlink "$DOTFILES_DIR/tmux/tmux.conf"       "$HOME/.tmux.conf"

# Ghostty
symlink "$DOTFILES_DIR/ghostty/config"       "$HOME/.config/ghostty/config"

# Git
symlink "$DOTFILES_DIR/.gitconfig"           "$HOME/.gitconfig"
symlink "$DOTFILES_DIR/.gitignore_global"    "$HOME/.gitignore_global"

# Starship
symlink "$DOTFILES_DIR/starship.toml"        "$HOME/.config/starship.toml"

ok "Symlinks"

# --- Tmux Plugin Manager ----------------------------------------------------
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  skip "TPM"
else
  info "Installing Tmux Plugin Manager…"
  git -c url."https://github.com/".insteadOf="git@github.com:" \
      clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM"
fi

# --- Neovim first launch (lazy.nvim will auto-install) ----------------------
# lazy.nvim's sync is idempotent — it only installs/updates what's needed
info "Syncing Neovim plugins (headless)…"
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
ok "Neovim plugins"

# --- Claude Code (installed via Brewfile cask "claude-code") ----------------
ok "Claude Code CLI (installed via brew)"

# --- macOS Defaults (idempotent: defaults write is a no-op if value matches) -
info "Applying macOS defaults…"
source "$DOTFILES_DIR/scripts/macos-defaults.sh"
ok "macOS defaults"

# --- Done -------------------------------------------------------------------
echo ""
ok "All done! Open a new terminal (Ghostty) and enjoy."
info "Reminder: press prefix + I in tmux to install TPM plugins."
info "Reminder: run ':checkhealth' in Neovim to verify setup."
