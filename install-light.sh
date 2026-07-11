#!/usr/bin/env bash
# =============================================================================
# Lightweight Install — for Macs that already have a dev environment
# =============================================================================
# Symlinks configs for Zsh, Neovim, Starship, Tmux, and Ghostty, then
# brew-installs any MISSING CLI tools, Neovim linters, and a small set of
# essential GUI apps (already-installed ones are skipped). Requires Homebrew.
# Does NOT install language runtimes or macOS defaults — use install.sh for
# the full setup.
# Idempotent: safe to re-run at any time. Backs up existing files.
#
# Usage: git clone <repo> ~/dotfiles && cd ~/dotfiles && ./install-light.sh
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

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    skip "  $dst"
    return
  fi
  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%s)"
    mv "$dst" "$backup"
    warn "  Backed up $dst → $backup"
  fi
  ln -sf "$src" "$dst"
  ok "  $dst → $src"
}

# --- Pre-flight checks ------------------------------------------------------
[[ "$(uname)" == "Darwin" ]] || fail "This script is for macOS only."

echo ""
info "Lightweight Dotfiles Installer"
info "Configs + essential CLI tools & apps — no language runtimes or macOS defaults"
echo ""

# Check Homebrew
if ! command_exists brew; then
  fail "Homebrew not found. Install from https://brew.sh first."
fi

# CLI tools required by .zshrc aliases and config
REQUIRED_TOOLS=(neovim tmux starship ripgrep fd eza bat dust duf procs btop lsd zoxide atuin tree-sitter-cli)

# Linters & formatters invoked by nvim (conform.nvim + nvim-lint).
# Without these, nvim emits ENOENT errors when opening matching filetypes.
NVIM_LINTERS=(yamllint shellcheck shfmt hadolint stylua prettier golangci-lint tflint ruff)

# Essential GUI apps (casks). Kept minimal — this is otherwise a CLI/config
# installer. Raycast is the cross-project window switcher used with tmux.
REQUIRED_CASKS=(raycast)

missing_tools=()
for tool in "${REQUIRED_TOOLS[@]}" "${NVIM_LINTERS[@]}"; do
  if ! brew list "$tool" &>/dev/null; then
    missing_tools+=("$tool")
  fi
done

if [[ ${#missing_tools[@]} -gt 0 ]]; then
  info "Installing missing CLI tools: ${missing_tools[*]}"
  brew install "${missing_tools[@]}"
  ok "CLI tools installed"
else
  ok "All CLI tools already installed"
fi

missing_casks=()
for cask in "${REQUIRED_CASKS[@]}"; do
  if ! brew list --cask "$cask" &>/dev/null; then
    missing_casks+=("$cask")
  fi
done

if [[ ${#missing_casks[@]} -gt 0 ]]; then
  info "Installing missing GUI apps: ${missing_casks[*]}"
  brew install --cask "${missing_casks[@]}"
  ok "GUI apps installed"
else
  ok "All GUI apps already installed"
fi

echo ""

# --- Zsh config -------------------------------------------------------------
info "Symlinking Zsh config…"
symlink "$DOTFILES_DIR/zsh/.zshrc"    "$HOME/.zshrc"
symlink "$DOTFILES_DIR/zsh/.zshenv"   "$HOME/.zshenv"
symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
ok "Zsh config"

# --- Neovim config ----------------------------------------------------------
info "Symlinking Neovim config…"
symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ok "Neovim config"

if command_exists nvim; then
  info "Syncing Neovim plugins (headless)…"
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
  ok "Neovim plugins synced"
fi

# --- Starship ---------------------------------------------------------------
info "Symlinking Starship config…"
symlink "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
ok "Starship config"

# --- Tmux -------------------------------------------------------------------
info "Symlinking Tmux config…"
symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  skip "  TPM (already installed)"
else
  if command_exists git; then
    info "Installing Tmux Plugin Manager…"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" 2>/dev/null || true
    ok "  TPM installed"
  else
    warn "  git not found — cannot install TPM"
  fi
fi

# Dracula theme (optional; loads only when TMUX_THEME=dracula). tmux.conf also
# self-installs it on first toggle, so this is just a pre-fetch. Kept outside
# ~/.tmux/plugins so TPM's clean-plugins won't remove it.
if [[ -d "$HOME/.tmux/dracula" ]]; then
  skip "  Dracula theme (already cloned)"
elif command_exists git; then
  info "Pre-fetching Dracula tmux theme…"
  git clone --depth 1 https://github.com/dracula/tmux "$HOME/.tmux/dracula" 2>/dev/null || true
  ok "  Dracula theme cloned"
fi
ok "Tmux config"

# --- Ghostty ----------------------------------------------------------------
info "Symlinking Ghostty config…"
symlink "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
ok "Ghostty config"

# --- Git config (opt-in) ----------------------------------------------------
echo ""
info "Git config contains hardcoded user.name and user.email."
info "Symlinking it will REPLACE your current ~/.gitconfig."
read -rp "Symlink .gitconfig? [y/N] " answer
if [[ "$answer" =~ ^[Yy] ]]; then
  symlink "$DOTFILES_DIR/.gitconfig"        "$HOME/.gitconfig"
  symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
  ok "Git config"
  warn "Update [user] in ~/.gitconfig if name/email don't match yours."
else
  # Always symlink gitignore_global — it's additive and safe
  symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
  skip "  .gitconfig (skipped by user)"
  ok "  .gitignore_global (safe, symlinked)"
fi

# --- Done -------------------------------------------------------------------
echo ""
ok "All done!"
echo ""
info "Next steps:"
info "  1. Open a new terminal to pick up Zsh config"
info "  2. Run 'nvim' and check :checkhealth"
info "  3. In tmux, press prefix + I to install TPM plugins"
info "  4. Add secrets to ~/.zshrc.local (see README for details)"
echo ""
info "For the full setup (brew packages, languages, macOS defaults), run ./install.sh instead."
echo ""
