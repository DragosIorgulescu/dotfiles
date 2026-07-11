# =============================================================================
# .zshrc — Interactive shell config
# =============================================================================

# --- Early exits for non-interactive -----------------------------------------
[[ $- != *i* ]] && return

# --- Completion System -------------------------------------------------------
autoload -Uz compinit
# Rebuild completion dump once a day
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*' group-name ''

# --- History -----------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY            # timestamp + duration
setopt INC_APPEND_HISTORY          # write immediately

# --- Shell Options -----------------------------------------------------------
setopt AUTO_CD                     # cd by typing dirname
setopt AUTO_PUSHD                  # pushd on every cd
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT                     # spell correction for commands
setopt INTERACTIVE_COMMENTS        # allow # in interactive
setopt NO_BEEP
setopt GLOB_DOTS                   # include hidden files in glob

# --- Vi Mode ----------------------------------------------------------------
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^K' kill-line
bindkey '^W' backward-kill-word
bindkey '^?' backward-delete-char  # backspace fix in vi mode

# Edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# --- Plugins (Homebrew-installed) -------------------------------------------
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

# --- Version Managers -------------------------------------------------------

# rbenv
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init - zsh)"
fi

# pyenv
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init - 2>/dev/null)"
fi

# nvm (lazy-loaded for fast shell startup)
# Any of these commands will trigger nvm to load on first use
_nvm_lazy_cmds=(nvm node npm npx)

_load_nvm() {
  unset -f "${_nvm_lazy_cmds[@]}"
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && source "$(brew --prefix nvm)/nvm.sh"
}

for cmd in "${_nvm_lazy_cmds[@]}"; do
  eval "${cmd}() { _load_nvm; ${cmd} \"\$@\"; }"
done
unset cmd

# --- FZF Configuration -------------------------------------------------------
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS="
    --height=60% --layout=reverse --border=rounded
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --bind='ctrl-/:toggle-preview'
    --preview='bat --style=numbers --color=always --line-range=:200 {} 2>/dev/null || tree -C {} 2>/dev/null'
  "
fi

# --- Atuin (shell history) ---------------------------------------------------
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# --- Zoxide (smarter cd) ----------------------------------------------------
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- direnv ------------------------------------------------------------------
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# --- Starship Prompt ---------------------------------------------------------
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# --- Aliases -----------------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern replacements (eza as default; lsd available as lsd/lll/llt)
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=3 --icons'
alias lsd='lsd --group-directories-first'
alias lll='lsd -la --group-directories-first'
alias llt='lsd --tree --depth=3'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias du='dust'
alias df='duf'
alias ps='procs'
alias top='btop'

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull --rebase'
alias lg='lazygit'

# Docker
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# Kubernetes
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'

# Neovim
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

# Tmux
alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'

# tmux session picker (opt-in). `ts` fuzzy-attaches an existing session;
# `ts <name>` attaches to <name> or creates it. Works in or out of tmux.
ts() {
  local session="${1:-$(tmux ls -F '#S' 2>/dev/null | fzf --height=40% --reverse --prompt='session> ')}"
  [[ -z "$session" ]] && return
  if [[ -n "$TMUX" ]]; then
    tmux has-session -t "$session" 2>/dev/null || tmux new-session -d -s "$session"
    tmux switch-client -t "$session"
  else
    tmux new-session -A -s "$session"
  fi
}

# Misc
alias c='clear'
alias reload='exec zsh'
alias path='echo $PATH | tr ":" "\n"'
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='curl -s ifconfig.me'
alias weather='curl -s "wttr.in?format=3"'

# --- Functions ---------------------------------------------------------------

# Create dir and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Git clone and cd
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick project switcher with fzf
proj() {
  local dir
  dir=$(fd --type d --max-depth 2 . ~/code ~/go/src ~/work 2>/dev/null | fzf --preview 'eza --tree --level=2 --icons {}')
  [[ -n "$dir" ]] && cd "$dir"
}

# Docker shell into running container
dsh() {
  local container
  container=$(docker ps --format '{{.Names}}' | fzf)
  [[ -n "$container" ]] && docker exec -it "$container" /bin/sh
}

# Kill process on port
killport() {
  lsof -ti ":$1" | xargs kill -9 2>/dev/null || echo "No process on port $1"
}

# --- Local overrides (not tracked in git) ------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
