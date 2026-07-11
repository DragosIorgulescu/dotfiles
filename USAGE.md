# How to Use & Maintain This Setup

This guide covers day-to-day usage of Neovim and Tmux, ongoing maintenance, and troubleshooting. Written for someone coming from VS Code or JetBrains who wants to get productive fast.

---

## Part 1: Neovim Survival Guide

If you're new to Neovim, start here. Everything below assumes you've already run the install script and opened Neovim with `v` (aliased to `nvim`).

### The Absolute Basics

Neovim has **modes**. This is the single most important concept:

- **Normal mode** — where you spend most of your time. You navigate, delete, copy, and run commands. You're in this mode when you first open Neovim.
- **Insert mode** — where you actually type text. Press `i` to enter, press `jk` or `Esc` to leave.
- **Visual mode** — for selecting text. Press `v` to start character selection, `V` for whole lines.
- **Command mode** — press `:` to type commands at the bottom of the screen.

If you're ever lost, press `Esc` a couple of times. You'll land back in Normal mode.

### Opening, Saving, and Closing Files

| What you want to do | How to do it |
|---------------------|-------------|
| Open Neovim | `v` or `nvim` in your terminal |
| Open a specific file | `v filename.go` or `nvim filename.go` |
| Open a file from inside Neovim | `<leader>ff` then type the filename |
| Save the current file | `<leader>w` (or `:w` then Enter) |
| Save all open files | `<leader>W` (or `:wa` then Enter) |
| Close the current file (buffer) | `<leader>bd` |
| Quit Neovim | `<leader>q` (or `:q` then Enter) |
| Quit without saving | `<leader>Q` (or `:q!` then Enter) |
| Save and quit | `:wq` then Enter |

**Important:** `q` by itself does NOT quit Neovim — it starts recording a macro. If you accidentally hit `q`, press `q` again to stop recording, then use one of the quit methods above.

### Moving Around

In Normal mode, you move with these keys instead of arrow keys (though arrow keys work too):

| Key | Movement |
|-----|----------|
| `h` | Left |
| `j` | Down |
| `k` | Up |
| `l` | Right |
| `w` | Jump forward one word |
| `b` | Jump back one word |
| `0` | Go to start of line |
| `$` | Go to end of line |
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `Ctrl+d` | Half-page down (centered) |
| `Ctrl+u` | Half-page up (centered) |
| `{` / `}` | Jump to previous / next paragraph |

### Editing Text

| What you want to do | How to do it |
|---------------------|-------------|
| Start typing text | `i` (insert before cursor) or `a` (insert after cursor) |
| Insert at start of line | `I` |
| Insert at end of line | `A` |
| Open new line below | `o` |
| Open new line above | `O` |
| Delete character under cursor | `x` |
| Delete current line | `dd` |
| Delete word | `dw` |
| Delete to end of line | `D` |
| Undo | `u` |
| Redo | `Ctrl+r` |
| Copy (yank) current line | `yy` |
| Copy to end of line | `Y` |
| Paste after cursor | `p` |
| Paste before cursor | `P` |
| Replace single character | `r` then the new character |
| Change word (delete + enter insert) | `cw` |
| Change entire line | `cc` |
| Change to end of line | `C` |

### Selecting and Acting on Text

Enter Visual mode with `v` (characters) or `V` (whole lines):

| What you want to do | How to do it |
|---------------------|-------------|
| Select characters | `v` then move with h/j/k/l |
| Select lines | `V` then move with j/k |
| Select a block/column | `Ctrl+v` then move |
| Copy selection | `y` (yanks and exits visual) |
| Delete selection | `d` |
| Change selection | `c` (deletes and enters insert) |
| Indent selection | `>` (right) or `<` (left) |
| Comment/uncomment selection | `gc` |
| Select inside quotes | `vi"` (try also `vi'`, `vi(`, `vi{`, `vi[`) |
| Select around quotes | `va"` (includes the quotes themselves) |
| Select inside function | `vif` (treesitter-aware) |
| Select around function | `vaf` (treesitter-aware) |

### Searching

| What you want to do | How to do it |
|---------------------|-------------|
| Search forward | `/searchterm` then Enter |
| Search backward | `?searchterm` then Enter |
| Next match | `n` |
| Previous match | `N` |
| Clear search highlights | `Esc` (we have this mapped) |
| Search and replace in file | `:%s/old/new/g` then Enter |
| Search across project | `<leader>fg` (Telescope live grep) |
| Search word under cursor | `<leader>fw` or `*` (forward) |
| Search & replace across project | `<leader>sr` (opens Spectre) |

### Working with Multiple Files

**Buffers** are open files. **Splits** show multiple files side by side. **Tabs** group splits.

| What you want to do | How to do it |
|---------------------|-------------|
| Open a file | `<leader>ff` and search |
| Switch between open files | `Shift+H` (prev) / `Shift+L` (next) |
| See all open buffers | `<leader>fb` |
| Close current buffer | `<leader>bd` |
| Split horizontally | `:split` or `:sp` |
| Split vertically | `:vsplit` or `:vsp` |
| Move between splits | `Ctrl+h/j/k/l` |
| Resize splits | `Ctrl+Up/Down/Left/Right` |
| Close a split | `Ctrl+w` then `q` |
| Pin files for quick access | `<leader>a` (Harpoon add) |
| Jump to pinned file | `<leader>1` through `<leader>5` |
| See pinned files | `Ctrl+E` (Harpoon menu) |

### The File Explorer

| What you want to do | How to do it |
|---------------------|-------------|
| Toggle file explorer | `<leader>n` |
| Reveal current file | `<leader>N` |
| Open file | `l` or `Enter` (in explorer) |
| Close folder | `h` (in explorer) |
| Create new file | `a` (in explorer) |
| Delete file | `d` (in explorer) |
| Rename file | `r` (in explorer) |

### Using the Terminal Inside Neovim

| What you want to do | How to do it |
|---------------------|-------------|
| Open floating terminal | `Ctrl+\` |
| Close/toggle terminal | `Ctrl+\` again |
| Exit terminal mode | `Esc Esc` (double press) |
| Open horizontal terminal | `<leader>th` |
| Open vertical terminal | `<leader>tv` |
| Open Lazygit | `<leader>tg` |
| Open Claude Code | `<leader>ll` |

### Getting Help

| What you want to do | How to do it |
|---------------------|-------------|
| Open cheat sheet | `<leader>?` |
| See all keymaps | `<leader>fk` |
| See which-key hints | Press `<leader>` and wait |
| Run health check | `:checkhealth` |
| Open help for a topic | `:help topic` (e.g., `:help telescope`) |
| Close help window | `q` |

---

## Part 2: Tmux Survival Guide

Tmux lets you have multiple terminal sessions, split panes, and persist your work through reboots.

### The Prefix Key

Almost all tmux commands start with the **prefix**: `Ctrl+A`. Press it, release, then press the next key. For example, to create a new window: press `Ctrl+A`, release both keys, then press `c`.

The one exception is `Ctrl+h/j/k/l` for pane navigation — these work without the prefix.

### Getting Around

| What you want to do | How to do it |
|---------------------|-------------|
| Split pane side by side | `prefix + \|` |
| Split pane top/bottom | `prefix + -` |
| Move between panes | `Ctrl+h/j/k/l` (no prefix!) |
| Resize panes | `prefix + H/J/K/L` (capital, repeatable) |
| Close current pane | `prefix + x` (or just type `exit`) |
| Make pane full screen | `prefix + z` (toggle zoom) |
| New window (like a tab) | `prefix + c` |
| Next window | `prefix + n` |
| Previous window | `prefix + p` |
| Go to window by number | `prefix + 1` through `prefix + 9` |
| Rename current window | `prefix + ,` |
| List all windows | `prefix + w` |

### Sessions (Workspaces)

Sessions are like workspaces — one per project. Each session has its own windows and panes.

| What you want to do | How to do it |
|---------------------|-------------|
| Create new session | `prefix + S` (prompted for name) |
| Switch sessions (FZF) | `prefix + o` (SessionX picker) |
| Switch to last session | `prefix + BTab` (backtab) |
| Kill current session | `prefix + X` |
| Detach (leave tmux running) | `prefix + d` |
| Reattach from terminal | `tmux a` or `tmux attach` |
| List sessions from terminal | `tmux ls` |

### Copying Text

| What you want to do | How to do it |
|---------------------|-------------|
| Enter copy mode | `prefix + [` |
| Move cursor | h/j/k/l or arrow keys |
| Start selection | `v` |
| Block/column selection | `Ctrl+v` |
| Copy selection | `y` (goes to system clipboard) |
| Exit copy mode | `Escape` or `q` |
| Scroll up | `prefix + [` then scroll or `Ctrl+u` |

### Quick Tools

| What you want to do | How to do it |
|---------------------|-------------|
| Open Lazygit | `prefix + g` |
| Open GitHub dashboard | `prefix + G` |
| Open Claude Code | `prefix + C` |
| Reload tmux config | `prefix + r` |
| Install tmux plugins | `prefix + I` (capital I, first time only) |

### Your Sessions Survive Reboots

tmux-resurrect + tmux-continuum save your session layout every 10 minutes. When you restart your Mac and open Ghostty, your tmux sessions, windows, and panes are automatically restored.

---

## Part 3: Maintenance & Keeping Up to Date

### Regular Updates

Run these periodically (weekly or monthly) to keep everything current:

```bash
# Update Homebrew and all packages
brew update && brew upgrade

# Update Neovim plugins (inside Neovim)
:Lazy update

# Update treesitter parsers (inside Neovim)
:TSUpdate

# Update Mason-managed tools (inside Neovim)
:Mason
# Then press U to update all

# Update tmux plugins
# prefix + U (capital U, in tmux)

# Update Rust toolchain
rustup update

# Update global npm packages (loads nvm first)
nvm use default && npm update -g
```

### Installing New Language Servers

To add support for a new language:

1. Find the server name at https://github.com/mason-org/mason-lspconfig.nvim (check the server mapping table).
2. Add it to the `ensure_installed` list in `nvim/lua/matei/plugins/lsp.lua`.
3. Add a `vim.lsp.config.<server_name> = { capabilities = capabilities }` block with any custom settings.
4. Restart Neovim — Mason will auto-install it.

Or install one-off from within Neovim:

```vim
:LspInstall <server_name>
```

To install interactively:

```vim
:Mason
```

Then search for the tool and press `i` to install.

### Installing New Treesitter Parsers

To add syntax highlighting for a new language:

1. Add the parser name to the `parsers` table in `nvim/lua/matei/plugins/treesitter.lua`.
2. Restart Neovim — missing parsers are installed automatically.

Or install one-off:

```vim
:TSInstall <language>
```

### Adding New Formatters and Linters

1. Install the tool via Mason (`:Mason`, search, press `i`) or add it to the Brewfile.
2. Add the formatter to `nvim/lua/matei/plugins/formatting.lua` under `formatters_by_ft`.
3. Add the linter to the `linters_by_ft` table in the same file.
4. Restart Neovim.

### Adding New Brew Packages

1. Add the formula or cask to `Brewfile`.
2. Run `brew bundle --file=~/dotfiles/Brewfile --verbose` to install.
3. To check if a package exists first: `brew search <name>` or `brew info <name>`.

---

## Part 4: Common Issues & Troubleshooting

### "Module not found" Errors on Neovim Startup

This usually means a plugin API has changed. The ecosystem moves fast (especially treesitter, mason, telescope). Steps:

1. Run `:Lazy update` to get the latest plugin versions.
2. If that doesn't fix it, check the plugin's GitHub for breaking changes.
3. Common culprits and their fixes:
   - **nvim-treesitter** — switched from `master` to `main` branch in 2025. Uses entirely new API.
   - **mason-lspconfig** — v2.0 removed `setup_handlers()`. Uses `vim.lsp.config()` now.
   - **telescope** — `0.1.x` branch is deprecated. Use `master`.

### Language Server Not Starting

1. Check `:Mason` — is the server installed? Press `i` to install if not.
2. Run `:LspInfo` to see what's attached to the current buffer.
3. Run `:checkhealth lsp` for diagnostic info.
4. Make sure the server is in both `ensure_installed` and has a `vim.lsp.config.<name>` entry in `lsp.lua`.

### Treesitter Highlighting Not Working

1. Check if the parser is installed: `:TSInstall <language>`.
2. Make sure the filetype is recognized: `:set ft?` shows the current filetype.
3. Parsers are only installed for languages in the `parsers` list — add yours if it's missing.

### Formatters Not Running on Save

1. Check `:ConformInfo` to see what formatter is configured for the current filetype.
2. Make sure the formatter is installed (check `:Mason` or `which <formatter>`).
3. Temporarily format manually: `<leader>cf`.

### Brew Bundle Fails

Common causes:
- **Package renamed** — search `brew search <name>` to find the current name.
- **Tap deprecated** — Homebrew occasionally merges taps into core. Remove the tap line.
- **Cask not found** — some casks use unexpected names (e.g., `docker-desktop` not `docker`, `linear-linear` not `linear`).

### Git Errors (delta not found)

The `.gitconfig` uses `delta` as a pager with a fallback to `less`. If you see delta-related errors before brew has finished installing:

```bash
# Install delta
brew install git-delta
```

### SSH Not Working with Git

The `.gitconfig` has an SSH rewrite (`url."git@github.com:".insteadOf`) that is **commented out by default**. This is intentional — it would break Homebrew and git clone operations before you've set up your SSH key.

After setting up your SSH key:

```bash
# Uncomment the SSH rewrite in .gitconfig
# Or set it globally:
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

### Tmux Plugins Not Loading

On first launch, plugins need to be installed:

```
prefix + I    (capital I)
```

If plugins still don't work, verify TPM is cloned:

```bash
ls ~/.tmux/plugins/tpm
# If empty, re-clone:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then reload config: `prefix + r`, and install: `prefix + I`.

---

## Part 5: Key Libraries & What They Do

Understanding what each major piece does helps you debug issues and extend your setup.

### Plugin Manager

| Tool | What It Does | Update Command |
|------|-------------|----------------|
| **lazy.nvim** | Manages all Neovim plugins, handles lazy-loading | `:Lazy update` |
| **Mason** | Installs LSP servers, formatters, linters, DAP adapters | `:Mason` then `U` |
| **TPM** | Tmux Plugin Manager | `prefix + U` |
| **Homebrew** | macOS package manager | `brew upgrade` |

### Core Neovim Plugins

| Plugin | Purpose | Why It Might Break |
|--------|---------|-------------------|
| **nvim-treesitter** | Syntax highlighting, text objects, indentation | Major API rewrites (happened in 2025). Check the `main` branch. |
| **mason-lspconfig** | Bridges Mason ↔ nvim-lspconfig | v2.0 was a breaking rewrite. `setup_handlers()` removed. |
| **telescope.nvim** | Fuzzy finder for files, grep, symbols | Must use `master` branch with new treesitter. |
| **nvim-lspconfig** | LSP client configuration | Server names occasionally change (e.g., `tsserver` → `ts_ls`). |
| **nvim-cmp** | Completion engine | Stable, but source plugins can lag behind. |
| **conform.nvim** | Format-on-save | Formatter names must match Mason package names. |
| **nvim-lint** | Async linting | Linter names must match Mason package names. |

### Version Managers

| Tool | Manages | Config Location |
|------|---------|----------------|
| **rbenv** | Ruby versions | `~/.rbenv/` |
| **pyenv** | Python versions | `~/.pyenv/` |
| **nvm** | Node.js versions | `~/.nvm/` (lazy-loaded) |
| **rustup** | Rust toolchain | `~/.cargo/` |

### Things That Can Go Stale

These should be checked during updates:

1. **Treesitter parsers** — run `:TSUpdate` after updating nvim-treesitter.
2. **Mason packages** — open `:Mason` and press `U` to update all.
3. **Homebrew formulae** — `brew upgrade` keeps CLI tools current.
4. **Tmux plugins** — `prefix + U` updates via TPM.
5. **Language toolchains** — `rustup update`, `rbenv install --list`, `pyenv install --list`, `nvm ls-remote`.

---

## Part 6: Neovim Config File Map

When you need to change something, here's where to look:

| I want to change... | Edit this file |
|---------------------|---------------|
| Vim options (tab size, line numbers, etc.) | `nvim/lua/matei/options.lua` |
| Global keymaps (not plugin-specific) | `nvim/lua/matei/keymaps.lua` |
| Auto-commands (format on save, etc.) | `nvim/lua/matei/autocmds.lua` |
| Color scheme | `nvim/lua/matei/plugins/colorscheme.lua` |
| File finder / Telescope | `nvim/lua/matei/plugins/telescope.lua` |
| Syntax highlighting / treesitter | `nvim/lua/matei/plugins/treesitter.lua` |
| Language servers (add/remove/configure) | `nvim/lua/matei/plugins/lsp.lua` |
| Completion behavior | `nvim/lua/matei/plugins/completion.lua` |
| Formatters and linters | `nvim/lua/matei/plugins/formatting.lua` |
| Git integration | `nvim/lua/matei/plugins/git.lua` |
| File explorer, harpoon, flash, surround | `nvim/lua/matei/plugins/editor.lua` |
| Terminal, tmux integration | `nvim/lua/matei/plugins/terminal.lua` |
| AI tools (Copilot, Claude, CodeCompanion) | `nvim/lua/matei/plugins/llm.lua` |
| Go-specific features | `nvim/lua/matei/plugins/go.lua` |
| Debugging (DAP) | `nvim/lua/matei/plugins/dap.lua` |
| Testing (Neotest) | `nvim/lua/matei/plugins/testing.lua` |
| UI (statusline, bufferline, which-key) | `nvim/lua/matei/plugins/ui.lua` |
| Cheat sheet content | `nvim/lua/matei/plugins/cheatsheet.lua` |
| Tmux config | `tmux/tmux.conf` |
| Zsh config | `zsh/.zshrc` |
| Shell environment variables | `zsh/.zshenv` |
| PATH setup | `zsh/.zprofile` |
| Homebrew packages | `Brewfile` |
| Git settings | `.gitconfig` |
| macOS defaults | `scripts/macos-defaults.sh` |
