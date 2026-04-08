#!/usr/bin/env bash
# =============================================================================
# Lightweight Install — for Macs that already have a dev environment
# =============================================================================
# Symlinks configs for Zsh, Neovim, Starship, Tmux, and Ghostty.
# Does NOT install Homebrew packages, language runtimes, or macOS defaults.
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
info "Symlinks only — no Homebrew, no language runtimes, no macOS defaults"
echo ""

# Check required tools
if ! command_exists nvim; then
  warn "Neovim not found — config will be symlinked but plugins won't sync"
  warn "Install with: brew install neovim"
fi

# Check recommended tools
for tool in rg fd starship tmux; do
  if command_exists "$tool"; then
    ok "$tool found"
  else
    case "$tool" in
      rg)       warn "ripgrep (rg) not found — Telescope live grep won't work" ;;
      fd)       warn "fd not found — Telescope file finder may be slower" ;;
      starship) warn "starship not found — prompt theme won't render. Install: brew install starship" ;;
      tmux)     warn "tmux not found — tmux config will be symlinked but won't be usable" ;;
    esac
  fi
done

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
