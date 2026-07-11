#!/usr/bin/env bash
# =============================================================================
# Dracula custom widget — Claude Code context-token usage.
# =============================================================================
# Prints the focused pane's Claude context size (e.g. "󰧑 62k"), or NOTHING when
# no Claude session is active. With `@dracula-show-empty-plugins false`, empty
# output makes Dracula hide the widget entirely (no box, no separator).
#
# Symlinked into ~/.tmux/dracula/scripts/llm-tokens.sh and referenced from
# tmux.conf as `custom:llm-tokens.sh`. Data comes from claude-statusline.sh.
#
# Self-adapting mode:
#   1. If the focused pane has a fresh per-tty file → show it (true per-pane).
#   2. Else if ANY per-tty file is fresh (tty correlation works, just not this
#      pane) → show nothing (this pane has no session).
#   3. Else fall back to the most-recent session (`latest`) — covers setups
#      where Claude's statusLine runs without the pane's tty (e.g. a pty-host
#      daemon), so we can't scope per-pane but still hide when idle.
#
# Tunables (env): DRACULA_LLM_ICON, DRACULA_LLM_STALE (seconds).
# =============================================================================
icon="${DRACULA_LLM_ICON:-󰧑}"          # nerd-font brain
stale="${DRACULA_LLM_STALE:-45}"        # older than this = session inactive → hide
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

# focused pane's tty — Dracula's own idiom for "the active pane"
ptty=$(tmux display-message -p '#{pane_tty}' 2>/dev/null)
ptty="${ptty##*/}"

# 1) strict per-pane
if [ -n "$ptty" ] && fresh "$cache/pane-$ptty"; then
  emit "$cache/pane-$ptty"; exit 0
fi

# 2) per-tty mechanism is working for some other pane → this pane has no session
for f in "$cache"/pane-*; do
  [ -e "$f" ] || continue
  fresh "$f" && exit 0                   # someone else's fresh session → stay empty
done

# 3) no usable per-tty data → most-recent active session
fresh "$cache/latest" && emit "$cache/latest"
exit 0
