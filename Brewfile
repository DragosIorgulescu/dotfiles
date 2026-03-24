# =============================================================================
# Brewfile — Comprehensive Dev Setup for macOS
# =============================================================================
# Install: brew bundle --file=Brewfile
# =============================================================================

# --- Taps -------------------------------------------------------------------
# homebrew/bundle and homebrew/services are now built into Homebrew core
tap "hashicorp/tap"
tap "jesseduffield/lazygit"

# --- Core CLI Tools ---------------------------------------------------------
brew "coreutils"                   # GNU core utilities
brew "findutils"                   # GNU find, xargs
brew "gnu-sed"                     # GNU sed
brew "grep"                        # GNU grep
brew "gawk"                        # GNU awk
brew "moreutils"                   # sponge, parallel, etc.
brew "tree"                        # directory tree
brew "htop"                        # process viewer
brew "btop"                        # resource monitor
brew "watch"                       # execute command periodically
brew "wget"                        # HTTP fetcher
brew "curl"                        # HTTP client (newer than system)
brew "jq"                          # JSON processor
brew "yq"                          # YAML processor
brew "fx"                          # interactive JSON viewer
brew "bat"                         # cat with syntax highlighting
brew "eza"                         # modern ls replacement
brew "fd"                          # modern find replacement
brew "sd"                          # modern sed replacement
brew "ripgrep"                     # fast grep (rg)
brew "fzf"                         # fuzzy finder
brew "zoxide"                      # smarter cd
brew "direnv"                      # per-directory env vars
brew "stow"                        # symlink farm manager
brew "trash"                       # move files to trash
brew "tldr"                        # simplified man pages
brew "dust"                        # disk usage analyzer
brew "duf"                         # disk usage (df replacement)
brew "procs"                       # ps replacement
brew "tokei"                       # code line counter
brew "hyperfine"                   # benchmarking tool
brew "entr"                        # run command on file change
brew "lsd"                         # ls with icons & colors
brew "atuin"                       # magical shell history (SQLite-backed, sync)

# --- Shell & Terminal -------------------------------------------------------
brew "zsh"                         # Z shell
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-completions"
brew "starship"                    # cross-shell prompt
brew "tmux"                        # terminal multiplexer
# reattach-to-user-namespace no longer needed on modern macOS + tmux 3.x

# --- Editor -----------------------------------------------------------------
brew "neovim"                      # Neovim (latest)
brew "luarocks"                    # Lua package manager (for nvim plugins)

# --- Git & VCS --------------------------------------------------------------
brew "git"                         # latest git
brew "git-lfs"                     # large file storage
brew "git-delta"                   # better diffs
brew "gh"                          # GitHub CLI
brew "lazygit"                     # TUI for git
brew "tig"                         # text-mode git interface

# --- Languages & Runtimes ---------------------------------------------------
brew "go"                          # Go language
brew "rbenv"                       # Ruby version manager
brew "ruby-build"                  # rbenv plugin
brew "nvm"                         # Node version manager
brew "pyenv"                       # Python version manager
brew "pyenv-virtualenv"            # pyenv venv plugin
brew "lua"                         # Lua runtime
brew "luajit"                      # Lua JIT compiler

# --- Infrastructure & DevOps -----------------------------------------------
brew "hashicorp/tap/terraform"     # Infrastructure as Code
brew "hashicorp/tap/packer"        # Machine image builder
brew "hashicorp/tap/vault"         # Secrets management
brew "awscli"                      # AWS CLI v2
brew "azure-cli"                   # Azure CLI
brew "kubectl"                     # Kubernetes CLI
brew "kubectx"                     # kubectl context switcher
brew "helm"                        # Kubernetes package manager
brew "kustomize"                   # Kubernetes config
brew "k9s"                         # Kubernetes TUI
brew "stern"                       # multi-pod log tailing
brew "terraform-docs"              # Terraform documentation
brew "tflint"                      # Terraform linter
brew "checkov"                     # IaC security scanner
brew "trivy"                       # vulnerability scanner

# --- Database Clients -------------------------------------------------------
brew "postgresql@16"               # PostgreSQL
brew "mysql-client"                # MySQL client
brew "redis"                       # Redis
brew "sqlite"                      # SQLite
brew "mongosh"                     # MongoDB shell

# --- API & Network Tools ----------------------------------------------------
brew "httpie"                      # user-friendly HTTP client
brew "grpcurl"                     # gRPC curl
brew "websocat"                    # WebSocket client
brew "nmap"                        # network scanner
brew "mtr"                         # traceroute + ping
brew "doggo"                       # DNS client (dig replacement)

# --- Build & Compilation ----------------------------------------------------
brew "cmake"                       # build system
brew "pkg-config"                  # library helper
brew "autoconf"                    # GNU autoconf
brew "automake"                    # GNU automake
brew "libtool"                     # GNU libtool
brew "openssl@3"                   # TLS toolkit
brew "readline"                    # input library
brew "libffi"                      # FFI library
brew "libyaml"                     # YAML parser

# --- Containers & Virtualization -------------------------------------------
brew "docker"                      # Docker CLI
brew "docker-compose"              # Docker Compose
brew "colima"                      # Docker runtime (no Docker Desktop)
brew "lima"                        # Linux VM manager

# --- Linters & Formatters ---------------------------------------------------
brew "shellcheck"                  # shell script linter
brew "shfmt"                       # shell script formatter
brew "yamllint"                    # YAML linter
brew "hadolint"                    # Dockerfile linter
brew "stylua"                      # Lua formatter
brew "prettier"                    # multi-language formatter
brew "eslint"                      # JS/TS linter
brew "golangci-lint"               # Go linter

# --- Security ---------------------------------------------------------------
brew "gnupg"                       # GPG encryption
brew "pinentry-mac"                # GPG PIN entry for macOS
brew "age"                         # modern encryption
brew "sops"                        # secrets in files
brew "pass"                        # password manager (CLI)

# --- Misc CLI ---------------------------------------------------------------
brew "imagemagick"                 # image manipulation
brew "ffmpeg"                      # video/audio processing
brew "pandoc"                      # document converter
brew "graphviz"                    # graph visualization
brew "figlet"                      # ASCII art text
brew "fastfetch"                   # system info display (neofetch successor)

# =============================================================================
# Casks (GUI Applications)
# =============================================================================

# --- Terminals & Editors ----------------------------------------------------
cask "ghostty"                     # GPU-accelerated terminal (Zig/Metal)
cask "visual-studio-code"          # VS Code
cask "antigravity"                 # Google Antigravity IDE
cask "claude-code"                 # Claude Code CLI (agentic coding)

# --- JetBrains IDEs ---------------------------------------------------------
cask "jetbrains-toolbox"           # manages all JetBrains IDEs
# Install GoLand, RubyMine, WebStorm, DataGrip etc. via Toolbox

# --- Browsers ---------------------------------------------------------------
cask "google-chrome"
cask "firefox"
cask "arc"                         # Arc browser

# --- Dev Tools --------------------------------------------------------------
cask "docker-desktop"               # Docker Desktop (alt: colima)
cask "postman"                     # API testing
cask "tableplus"                   # database GUI
cask "fork"                        # Git GUI
cask "charles"                     # HTTP proxy/debugger
cask "ngrok"                       # local tunnel

# --- Communication ----------------------------------------------------------
cask "slack"                       # team chat
cask "discord"                     # community chat
cask "zoom"                        # video calls
cask "linear-linear"               # project management

# --- Productivity -----------------------------------------------------------
cask "raycast"                     # Spotlight replacement + snippets
cask "1password"                   # password manager
cask "notion"                      # notes & docs
cask "obsidian"                    # knowledge base
cask "rectangle"                   # window management
cask "karabiner-elements"          # keyboard customization
cask "contexts"                    # window switcher

# --- Design -----------------------------------------------------------------
cask "figma"                       # UI design

# --- Utilities --------------------------------------------------------------
cask "the-unarchiver"              # archive extraction
cask "appcleaner"                  # clean app uninstalls
cask "stats"                       # menu bar system monitor
cask "aldente"                     # battery management
cask "iina"                        # video player

# --- Fonts ------------------------------------------------------------------
cask "font-jetbrains-mono-nerd-font"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"
cask "font-meslo-lg-nerd-font"
cask "font-caskaydia-cove-nerd-font"
cask "font-inter"

# =============================================================================
# VS Code Extensions (optional — uncomment if desired)
# =============================================================================
# vscode "golang.go"
# vscode "hashicorp.terraform"
# vscode "ms-vscode-remote.remote-containers"
# vscode "github.copilot"
# vscode "bradlc.vscode-tailwindcss"
# vscode "dbaeumer.vscode-eslint"
# vscode "esbenp.prettier-vscode"
