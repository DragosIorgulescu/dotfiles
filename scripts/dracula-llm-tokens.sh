#!/usr/bin/env bash
# =============================================================================
# Dracula custom widget — Claude Code context-token usage, scoped to the pane.
# =============================================================================
# Prints the focused pane's Claude context size (e.g. "󰧑 62k"), or NOTHING when
# that pane has no active Claude session. With `@dracula-show-empty-plugins
# false`, empty output makes Dracula hide the widget entirely.
#
# Correlation is by working directory: the hook (claude-statusline.sh) writes
# cwd-<slug> keyed by the session's cwd, and here we look it up from the focused
# pane's #{pane_current_path}. (Claude 2.x has no per-pane tty — cwd is the only
# shared identifier. So it maps a *directory* to a session, not literally a pane:
# a Claude session running in — or as a popup over — a pane whose dir it shares
# shows here; two sessions in the same dir would collide.)
#
# Self-adapting:
#   1. focused pane's dir has a fresh session → show it
#   2. some other dir has a fresh session (mechanism works, not this pane) → hide
#   3. no per-dir data at all → optional global fallback (DRACULA_LLM_GLOBAL=1)
#
# Tunables (env): DRACULA_LLM_ICON, DRACULA_LLM_STALE (s), DRACULA_LLM_GLOBAL.
# Debug: cat ${XDG_CACHE_HOME:-~/.cache}/claude-tokens/.last
# =============================================================================
icon="${DRACULA_LLM_ICON:-󰧑}"          # nerd-font brain
stale="${DRACULA_LLM_STALE:-60}"        # older than this = session inactive → hide
cache="${XDG_CACHE_HOME:-$HOME/.cache}/claude-tokens"

[ -d "$cache" ] || exit 0

fresh() {                               # $1=file → true if modified within $stale s
  [ -f "$1" ] || return 1
  local now mt
  now=$(date +%s)
  # GNU stat first (-c %Y); it errors cleanly on BSD, where we fall back to -f %m.
  # (Doing it the other way round mis-fires: GNU `stat -f` is filesystem mode.)
  mt=$(stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null)
  case "$mt" in '' | *[!0-9]*) return 1 ;; esac   # non-numeric → treat as not fresh
  [ $((now - mt)) -le "$stale" ]
}

emit() { printf '%s %s' "$icon" "$(head -n1 "$1")"; }

# focused pane's working directory — matches the hook's cwd key
ppath=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
ppath="${ppath%/}"
slug=$(printf '%s' "$ppath" | tr -c 'A-Za-z0-9' '-')

# 1) this pane's directory has a fresh Claude session
if [ -n "$ppath" ] && fresh "$cache/cwd-$slug"; then
  emit "$cache/cwd-$slug"; exit 0
fi

# 2) the cwd mechanism is producing files (just not for this pane) → stay empty
for f in "$cache"/cwd-*; do
  [ -e "$f" ] || continue
  fresh "$f" && exit 0
done

# 3) no usable per-dir data → optional global fallback (off by default)
if [ "${DRACULA_LLM_GLOBAL:-0}" = 1 ]; then
  fresh "$cache/latest" && emit "$cache/latest"
fi
exit 0
