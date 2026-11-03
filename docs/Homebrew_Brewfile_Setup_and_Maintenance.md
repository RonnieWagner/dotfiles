# Homebrew Brewfile — macOS Setup and Maintenance

**Repository:** [RonnieWagner/dotfiles](https://github.com/RonnieWagner/dotfiles)  
**Platform:** macOS (MacBook Air M3)  
**Brewfile location:** `~/dotfiles/Brewfile`  
**Initial Brewfile commit:** `315e1a9` — `Add Homebrew Brewfile for reproducible macOS setup` (November 2, 2026)

## Purpose

The Brewfile describes the software installed on the Mac so that the same tools and applications can be restored on another macOS installation. It works with the existing GNU Stow-managed `dotfiles` repository:

- **Homebrew Bundle** installs tools, applications, and selected editor extensions.
- **GNU Stow** links personal configuration files into the appropriate locations.

The Brewfile does **not** reproduce every system setting, login session, application preference, permission, or secret.

## What the current Brewfile includes

The file was created using `brew bundle dump` on the existing MacBook. At the time of creation, `brew bundle` reported **66 dependencies satisfied**. It includes:

| Category | Examples |
|---|---|
| Homebrew taps | `areofyl/fetch`, `felixkratz/formulae`, `nikitabobko/tap` |
| Command-line tools | `git`, `neovim`, `tmux`, `stow`, `starship`, `fzf`, `jq`, `bat`, `btop`, `powershell`, `pyenv`, `rclone` |
| macOS desktop customization | `aerospace`, `felixkratz/formulae/sketchybar`, `felixkratz/formulae/borders`, `ghostty`, `sol`, `spaceman` |
| Applications | `joplin`, `bitwarden`, `libreoffice`, `localsend`, `moonlight`, `github`, `codex`, `pdf-reader-pro` |
| VS Code extensions | GitLens, Python/Pylance, PowerShell, Remote-SSH, GitHub Pull Requests, themes and visual customizations |
| Go installation | `github.com/bootdotdev/bootdev` |

**Important:** These are the entries captured from the existing installation, not a vetted minimum required on every future Mac. Consult the committed `Brewfile` for the authoritative package list.

## Everyday commands

Run these from any terminal unless a working directory is explicitly required.

### Check for updates

```bash
brew update                # Refresh Homebrew package metadata
brew outdated              # Show packages with available updates
```

### Upgrade installed packages

```bash
brew upgrade
```

For a specific cask:

```bash
brew upgrade --cask joplin
```

Close applications with unsaved work before upgrades. Homebrew may quit and replace a running application during a cask upgrade.

### Verify Brewfile dependencies

```bash
cd ~/dotfiles
brew bundle check --file=./Brewfile
```

This checks whether the listed dependencies are present. It does not install them.

### Install missing Brewfile dependencies

```bash
cd ~/dotfiles
brew bundle install --file=./Brewfile
```

This reads the Brewfile and installs missing items. It does not normally reinstall packages that are already satisfied. Review the file before using it on a new machine because third-party taps, applications, and extensions are included.

## Adding a new application

1. Install it normally using Homebrew, for example:

   ```bash
   brew install --cask <cask-name>
   ```

2. Open `~/dotfiles/Brewfile` in your editor and add the appropriate entry, for example:

   ```ruby
   cask "joplin"
   ```

3. Check the Brewfile:

   ```bash
   cd ~/dotfiles
   brew bundle check --file=./Brewfile
   git diff -- Brewfile
   ```

4. Commit and push when the changes are correct:

   ```bash
   git add Brewfile
   git commit -m "Update Homebrew package list"
   git push origin main
   ```

**Why edit manually?** `brew bundle dump` inventories the current machine, which may include experimental software. Prefer maintaining a curated Brewfile rather than automatically overwriting it after every installation.

### Regenerating the inventory (only when intentional)

```bash
cd ~/dotfiles
brew bundle dump --file=./Brewfile
```

If a Brewfile already exists, this may refuse to overwrite it. Avoid using `--force` without first inspecting and preserving local edits. If you do regenerate it, review the diff before committing.

## Fresh Mac restoration

The order matters: install the required tools first, then apply personal configurations.

### 1. Install Homebrew

Follow the current instructions at [brew.sh](https://brew.sh/) and verify:

```bash
brew --version
```

Set up the Homebrew shell environment as instructed by the installer, since the prefix varies by architecture and installation.

### 2. Clone the existing repository

```bash
git clone https://github.com/RonnieWagner/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**Do not clone over an existing `~/dotfiles` directory.** If it's already present, use `cd ~/dotfiles` and inspect `git status` instead.

### 3. Install the Brewfile software

```bash
brew bundle install --file=./Brewfile
brew bundle check --file=./Brewfile
```

Some packages may require prompts, macOS permissions, application login, or other manual setup.

### 4. Restore configurations with GNU Stow

After inspecting the repository and checking for pre-existing target files, deploy only the appropriate Stow packages. For example:

```bash
cd ~/dotfiles
stow ghostty starship tmux
```

Add other packages only after inspecting their layout and any existing destination files. Do not blindly Stow all directories; some packages and settings are machine- or macOS-version-specific.

### 5. Finish machine-specific setup

Verify Git authentication, SSH keys, macOS privacy/accessibility permissions, AeroSpace/SketchyBar startup behavior, application logins, and any private settings. These are not automatically restored by the Brewfile.

## Joplin migration notes

Joplin was originally installed manually, then moved under Homebrew management:

1. Existing Joplin application: **3.7.21**.
2. `brew install --cask --adopt joplin` declined adoption because the Homebrew version was **3.7.22**.
3. A backup copy of the profile was created at:
   `~/JoplinBackup/pre-homebrew-migration/`
4. The previous application bundle was moved to:
   `~/JoplinBackup/Joplin-3.7.21.app`
5. `brew install --cask joplin` successfully installed **3.7.22**.
6. `brew list --cask` and `brew upgrade --cask joplin` confirmed Homebrew management and that the installed version was current at the time.

The active Joplin profile is normally located at `~/.config/joplin-desktop/`. **Do not delete the backups until the notes, attachments, settings, and synchronization have been checked in Joplin.** Avoid `brew uninstall --zap joplin` when trying to preserve application data.

## Git milestones

- Initial macOS customization: prior commits in `main`.
- **`315e1a9`** — Added the 105-line `Brewfile` and pushed to `origin/main`.
- `brew bundle check`: **dependencies satisfied**.
- `brew bundle install`: **66 dependencies installed/satisfied**.

## Troubleshooting

| Message | Meaning / action |
|---|---|
| `No Brewfile found` | Run commands from `~/dotfiles`, or specify `--file=~/dotfiles/Brewfile`. |
| `destination path ... already exists` during `git clone` | The repo is already there; do not clone over it. `cd ~/dotfiles` instead. |
| `Using <package>` | Homebrew Bundle recognizes the dependency as already present. |
| `The Brewfile's dependencies are satisfied.` | All listed dependencies passed the check. |
| `brew outdated` produces no output | Homebrew detects no outdated packages at that moment. |
| `?? Brewfile` in `git status --short` | New untracked Brewfile; stage using `git add Brewfile`. |
| `A` / `[+]` status in the prompt | File staged in Git (prompt symbol depends on Starship configuration). |

## Maintenance principles

- Keep the Brewfile **curated**: include software you intend to reproduce.
- Never commit passwords, API tokens, or private keys.
- Review third-party taps and `trusted: true` entries when setting up a new Mac.
- Run `git diff` and `brew bundle check` after modifying the Brewfile.
- Keep applications and their configurations separate: Brewfile handles installation, Stow handles dotfiles.
- Maintain a separate list for machine-specific permissions and setup steps that can't be automated safely.
