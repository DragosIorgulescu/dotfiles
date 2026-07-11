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
# It publishes the token count under ${XDG_CACHE_HOME:-~/.cache}/claude-tokens:
#   • cwd-<slug>  — keyed by the session's working directory. This is the only
#                   identifier the tmux widget can also derive (from the focused
#                   pane's #{pane_current_path}), so it's how per-pane scoping
#                   works. (Claude 2.x runs each session through a detached
#                   pty-host daemon with no controlling tty, so tty/pane-id
#                   correlation isn't available — cwd is.)
#   • latest      — most-recent session (only used if the widget's global mode
#                   is enabled).
#   • .last       — debug: the cwd/slug/tokens last written.
# Freshness (file mtime) is what the widget uses to decide "session is active".
#
# Deliberately NOT `set -e`: a status line must never crash — degrade instead.
# =============================================================================

json=$(cat)

field() { printf '%s' "$json" | jq -r "$1" 2>/dev/null; }

transcript=$(field '.transcript_path // empty')
model=$(field '.model.display_name // .model.id // "claude"')
# Prefer the real cwd (matches tmux #{pane_current_path}); fall back to workspace.
cwd=$(field '.cwd // .workspace.current_dir // empty')
cwd="${cwd%/}"

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
  if [ -n "$cwd" ]; then
    slug=$(printf '%s' "$cwd" | tr -c 'A-Za-z0-9' '-')
    printf '%s\n' "$tokens" > "$cache/cwd-$slug" 2>/dev/null
    printf 'cwd=%s\nslug=%s\ntokens=%s\n' "$cwd" "$slug" "$tokens" > "$cache/.last" 2>/dev/null
  fi
  # tidy: drop per-dir files older than a day so stale sessions don't accumulate
  find "$cache" -name 'cwd-*' -type f -mtime +1 -delete 2>/dev/null
fi

# --- the status line shown inside Claude Code -------------------------------
dir="${cwd:+$(basename "$cwd")}"
printf '%s' "${dir:+$dir  }$model${tokens:+  ${tokens} ctx}"
