#!/usr/bin/env bash
# =============================================================================
# Claude Code statusLine hook — renders Claude's status line AND publishes the
# current session's context-token count for the tmux/Dracula "llm-tokens" widget.
# =============================================================================
# Claude invokes this on updates, passing session JSON on stdin. Wire it up in
# ~/.claude/settings.json:
#   "statusLine": { "type": "command",
#                   "command": "~/dev/dotfiles/scripts/claude-statusline.sh" }
#
# It writes the token count to two files under ${XDG_CACHE_HOME:-~/.cache}/claude-tokens:
#   • latest        — always (most-recent active session; global fallback)
#   • pane-<tty>    — best-effort, only when this process has a controlling tty
#                     (lets the widget scope to the focused pane; see the widget)
# Freshness (file mtime) is what the widget uses to decide "session is active".
#
# Deliberately NOT `set -e`: a status line must never crash — degrade instead.
# =============================================================================

json=$(cat)

field() { printf '%s' "$json" | jq -r "$1" 2>/dev/null; }

transcript=$(field '.transcript_path // empty')
model=$(field '.model.display_name // .model.id // "claude"')
cwd=$(field '.workspace.current_dir // .cwd // empty')

# Current context = the last usage entry's input + cache_read + cache_creation.
ctx=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  ctx=$(jq -r 'select(.message.usage != null)
        | (.message.usage.input_tokens
           + (.message.usage.cache_read_input_tokens // 0)
           + (.message.usage.cache_creation_input_tokens // 0))' \
        "$transcript" 2>/dev/null | tail -n1)
fi

tokens=""
if [ -n "$ctx" ] && [ "$ctx" -gt 0 ] 2>/dev/null; then
  if [ "$ctx" -ge 1000 ]; then tokens="$((ctx / 1000))k"; else tokens="$ctx"; fi
fi

# --- publish to cache for the tmux widget -----------------------------------
cache="${XDG_CACHE_HOME:-$HOME/.cache}/claude-tokens"
mkdir -p "$cache" 2>/dev/null
if [ -n "$tokens" ]; then
  printf '%s\n' "$tokens" > "$cache/latest" 2>/dev/null
  tty=$(ps -o tty= -p $$ 2>/dev/null | tr -d ' ')
  case "$tty" in
    "" | "?" | "??") : ;;                                   # no tty → skip per-pane
    *) printf '%s\n' "$tokens" > "$cache/pane-${tty##*/}" 2>/dev/null ;;
  esac
  # tidy: drop per-pane files older than a day so stale ttys don't accumulate
  find "$cache" -name 'pane-*' -type f -mtime +1 -delete 2>/dev/null
fi

# --- the status line shown inside Claude Code -------------------------------
dir="${cwd:+$(basename "$cwd")}"
printf '%s' "${dir:+$dir  }$model${tokens:+  ${tokens} ctx}"
