# Dotfiles

My personal macOS development environment and terminal configurations, managed with Git and GNU Stow.

I maintain this repository to keep my development environment consistent, track configuration changes, and make it easier to reproduce my setup across machines.

It's also a hands-on learning project as I continue developing my skills in software engineering, shell scripting, Git, and system administration.

## Tech Stack

| Tool | Purpose |
|---|---|
| [Ghostty](https://ghostty.org/) | Terminal emulator |
| [Zsh](https://www.zsh.org/) | Interactive shell |
| [Starship](https://starship.rs/) | Customized Powerline-style shell prompt |
| [AeroSpace](https://nikitabobko.github.io/AeroSpace/) | Tiling window manager |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Active window border highlighting |
| [Sol](https://github.com/ospfranco/sol) | macOS productivity utilities |
| [tmux](https://github.com/tmux/tmux/wiki) | Terminal multiplexer and session management |
| [GNU Stow](https://www.gnu.org/software/stow/) | Dotfile symlink management |
| [Git](https://git-scm.com/) | Version control |

**Primary environment:** Apple Silicon MacBook Air running macOS.

## Repository Structure

```text
dotfiles/
├── aerospace/       # Tiling window manager
├── borders/          # JankyBorders configuration
├── ghostty/          # Terminal settings and theme
├── sol/              # Productivity utility settings
├── starship/         # Custom Powerline prompt
├── tmux/             # Terminal multiplexer
├── zsh/              # Shell initialization
├── .gitignore
└── README.md
```

Each package mirrors the configuration path expected by its application.

For example:

```text
~/dotfiles/starship/.config/starship.toml
                     |
                     v
~/.config/starship.toml
```

GNU Stow manages the symbolic links, allowing applications to read their configurations from standard locations while the source files remain under Git version control.

## Terminal Environment

### Ghostty + Zsh + Starship

My terminal environment combines Ghostty, Zsh, and a customized Starship prompt using the Catppuccin Mocha color palette.

The prompt includes:

- Powerline-style segments
- Current directory
- Git branch and working-tree status
- Command success or failure
- Python environment information when applicable
- Right-aligned system information and clock

The goal is to keep useful development information visible without cluttering the terminal.

Machine-specific shell settings are stored in `~/.zshrc.local`, outside this repository.

## Window Management

### AeroSpace

AeroSpace provides keyboard-driven tiling and workspace management.

My workflow uses three primary workspaces:

| Workspace | Purpose |
|---|---|
| `DEV` | VS Code, software development, and documentation |
| `LAB` | Ghostty, SSH, tmux, and infrastructure administration |
| `WEB` | Browsing, email, and communications |

#### Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Option + 1` | Switch to DEV |
| `Option + 2` | Switch to LAB |
| `Option + 3` | Switch to WEB |
| `Option + Shift + 1/2/3` | Move focused window to selected workspace |
| `Option + H/J/K/L` | Focus windows by direction |
| `Option + Shift + H/J/K/L` | Move windows by direction |
| `Option + T` | Create a new Ghostty window |
| `Option + B` | Launch or activate Firefox |
| `Option + M` | Launch or activate Mail |
| `Option + Shift + ;` | Enter AeroSpace service mode |

AeroSpace is launched through macOS Login Items rather than its built-in startup setting.

Configuration reloads are performed manually:

```bash
aerospace reload-config
```

Persistent workspaces maintain workspace identities but do not automatically restore application windows or their exact layouts after a restart.

### JankyBorders

JankyBorders provides visual highlighting around the focused window, making it easier to identify the active window when using AeroSpace's tiling layouts.

Its configuration is maintained in the `borders/` package.

### Sol

Sol provides additional macOS productivity features alongside AeroSpace.

My configuration includes:

- Window positioning and resizing shortcuts
- Clipboard manager (`Command + Option + V`)
- Scratchpad (`Command + Shift + Space`)
- Calendar integration and upcoming event visibility
- DuckDuckGo search
- Automatic launch at login

Sol's window-management shortcuts primarily use `Control + Option` combinations, separate from AeroSpace's `Option`-based navigation shortcuts.

The configuration is stored at:

```text
sol/.config/sol/config.json
```

## Terminal Session Management

### tmux

tmux provides terminal session management, allowing me to organize development and administrative work into sessions, windows, and panes.

It's particularly useful when working with SSH connections and multiple systems.

My current configuration is intentionally minimal:

```tmux
set -g mouse on
```

This enables mouse interaction while retaining tmux's default keybindings and behavior.

Common commands:

```bash
# Create a named session
tmux new -s development

# List existing sessions
tmux list-sessions

# Attach to an existing session
tmux attach -t development
```

To detach without terminating a session, press `Ctrl + B`, followed by `D`.

Verbose tmux diagnostic logs are excluded from Git through `.gitignore`.

## Installation

### 1. Install Prerequisites

Install Git, GNU Stow, and the applications whose configurations you intend to use.

On macOS with Homebrew:

```bash
brew install git stow
```

The remaining applications must be installed separately.

This repository does not currently include an automated installer or bootstrap script.

### 2. Clone the Repository

```bash
git clone https://github.com/RonnieWagner/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Preview Configuration Links

Always preview changes before deploying a package:

```bash
stow -n -v --no-folding -t "$HOME" ghostty starship
```

| Option | Description |
|---|---|
| `-n` | Dry run; do not create links |
| `-v` | Show planned operations |
| `--no-folding` | Create links to files instead of folding entire directories |
| `-t "$HOME"` | Set the home directory as the target |

### 4. Deploy Terminal Configurations

After reviewing the dry-run output:

```bash
stow -v --no-folding -t "$HOME" ghostty starship
```

Before deploying Zsh, back up any existing `~/.zshrc` and preview the changes:

```bash
stow -n -v --no-folding -t "$HOME" zsh
stow -v --no-folding -t "$HOME" zsh
```

### 5. Deploy Additional Packages

Preview:

```bash
stow -n -v --no-folding -t "$HOME" aerospace borders sol tmux
```

Deploy after checking for conflicts:

```bash
stow -v --no-folding -t "$HOME" aerospace borders sol tmux
```

**Important:** GNU Stow will report conflicts with existing files rather than automatically overwrite them. Review and back up existing configurations before deploying.

Only deploy packages appropriate for the target machine.

## Configuration Maintenance

Configuration changes are tracked through Git.

### Review Changes

```bash
cd ~/dotfiles
git status --short
git diff
```

### Stage and Inspect

```bash
git add -- path/to/config
git diff --cached
git diff --cached --check
```

### Commit and Push

```bash
git commit -m "Describe configuration change"
git push origin main
```

I prefer focused commits that describe individual changes, making the repository history easier to understand and troubleshoot.

## Portability and Limitations

- The configuration is developed and tested primarily on macOS.
- Ghostty, Starship, Zsh, and tmux may be reusable on other supported platforms, but a complete Linux deployment has not yet been verified.
- AeroSpace, JankyBorders, and Sol are macOS-specific components.
- Application installation is currently manual.
- Some configurations may require adjustments for different machines or workflows.
- AeroSpace does not automatically restore complete application layouts after restarting macOS.
- A fully tested automated recovery process has not yet been implemented.

## Security

This is a public repository.

Credentials, API tokens, passwords, SSH private keys, and sensitive machine-specific information should never be committed.

Local overrides and secrets should remain outside version control.

## Roadmap

- [ ] Validate configuration deployment on a clean macOS installation
- [ ] Test portable configurations on Linux
- [ ] Document application dependencies and startup behavior
- [ ] Improve workspace and application restoration
- [ ] Evaluate an automated setup/bootstrap script
- [ ] Continue refining terminal and development workflows

## Why I Maintain This Repository

My background is in IT support and infrastructure administration, and I'm working toward a career in software development.

Maintaining this repository gives me practical experience with Git, shell environments, configuration management, troubleshooting, and technical documentation.

Beyond customizing my desktop, the goal is to understand how the tools work, make intentional improvements, and build an environment I can reliably maintain and reproduce.
