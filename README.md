# Dotfiles

My personal macOS development environment and terminal configurations, managed with Git and GNU Stow.

I maintain this repository to keep my development environment consistent, track configuration changes, and make it easier to reproduce my setup across machines.

It's also a hands-on learning project as I continue developing my skills in software engineering, shell scripting, Git, and system administration.

## Documentation

- [Homebrew Setup and Maintenance](docs/Homebrew_Brewfile_Setup_and_Maintenance.md)

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

Ghostty uses Catppuccin Mocha with 90% background opacity, a blur setting of 20, and 10-pixel window padding. These settings provide a translucent terminal appearance while preserving readability.

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

My workflow uses numbered workspaces (`1` through `9`) rather than fixed DEV/LAB/WEB/MEDIA names. `Option + number` switches to or creates a numbered workspace as needed. With `config-version = 2` and `persistent-workspaces = []`, empty, invisible workspaces are not retained unnecessarily.

AeroSpace launches at login using `start-at-login = true`. I use its native macOS menu bar integration, including the service-mode indicator, rather than SketchyBar.

The configured gaps are 15 pixels between tiled windows, 10 pixels at the left, right, and bottom edges, and 5 pixels at the top. Nested tiling and accordion containers allow a stack of windows on one side while another window stays visible.

#### Keyboard Shortcuts
| Shortcut | Action |
|---|---|
| `Option + 1` through `Option + 9` | Switch to numbered workspaces |
| `Option + Shift + 1` through `Option + Shift + 9` | Move the focused window to a numbered workspace |
| `Option + H/J/K/L` | Focus windows by direction |
| `Option + Shift + H/J/K/L` | Move windows by direction in main mode |
| `Option + /` | Cycle tile orientations |
| `Option + ,` | Cycle accordion orientations |
| `Option + Shift + ;` | Enter AeroSpace service mode |

Additional application shortcuts and service-mode actions are defined in `aerospace/.config/aerospace/aerospace.toml`.

Configuration reloads are performed manually:

```bash
aerospace reload-config
```

AeroSpace does not automatically restore every application window or exact nested layout after a macOS restart.

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

Below is my current configuration:


This allows me to use my mouse to resize panes by clicking on them and dragging them with my mouse

```bash
tmux set -g mouse on
 ```
- Appearance: Catppuccin Mocha with rounded window labels.
- Feedback: a prefix indicator after pressing Ctrl+b.
- Help: Ctrl+b, ? opens floating help; Esc closes it.
- Dependency: Catppuccin v2.3.2 must be downloaded separately to ~/.local/share/tmux/plugins/catppuccin.

new-machine installation instructions:
The catppuccin Mocha theme needs to be downloaded separately. You can find it here:

```bash
mkdir -p ~/.local/share/tmux/plugins
git clone --branch v2.3.2 --depth 1 https://github.com/catppuccin/tmux.git ~/.local/share/tmux/plugins/catppuccin
```

Common commands:

```bash
# Create a named session
tmux new -s development

# List existing sessions
tmux list-sessions

# Attach to an existing session
tmux attach -t development

# Reload tmux configuration from a running tmux session
tmux source-file ~/.config/tmux/tmux.conf
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
