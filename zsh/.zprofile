# =============================================================================
# .zprofile — loaded for LOGIN shells only (once per session)
# PATH construction goes here.
# =============================================================================

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Build PATH (later entries take priority)
typeset -U path  # deduplicate

path=(
  "$HOME/.local/bin"
  "$GOBIN"
  "$CARGO_HOME/bin"
  "$PYENV_ROOT/bin"
  "$HOME/.rbenv/bin"
  "$(brew --prefix)/opt/coreutils/libexec/gnubin"
  "$(brew --prefix)/opt/findutils/libexec/gnubin"
  "$(brew --prefix)/opt/gnu-sed/libexec/gnubin"
  "$(brew --prefix)/opt/grep/libexec/gnubin"
  "$path[@]"
)

export PATH
