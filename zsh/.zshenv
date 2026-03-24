# =============================================================================
# .zshenv — loaded for EVERY zsh session (login, interactive, script)
# Keep this minimal — only universal env vars belong here.
# =============================================================================

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"

# Rust
export CARGO_HOME="$HOME/.cargo"

# NVM
export NVM_DIR="$HOME/.nvm"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"

# Reduce key timeout (faster Esc in vim mode)
export KEYTIMEOUT=1
