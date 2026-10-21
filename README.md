# dotfiles

My terminal configuration files. I keep them in Git so I can reuse the same setup across machines without starting from scratch each time.

I use [GNU Stow](https://www.gnu.org/software/stow/) to link the files from this repository into the locations where the applications expect them.

## What's here

- `ghostty/` — Ghostty settings, including the Catppuccin Mocha theme.
- `starship/` — Prompt colors and Git information.
- `zsh/` — Zsh startup, Starship initialization, and optional shell plugins.

Machine-specific settings stay in `~/.zshrc.local`, which isn't part of this repository.

## Setup

Install Git, GNU Stow, Ghostty, and Starship separately, then clone the repo:

```sh
git clone https://github.com/RonnieWagner/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Preview the links before creating them:

```sh
stow -n -v --no-folding -t "$HOME" ghostty starship
stow -v --no-folding -t "$HOME" ghostty starship
```

If you're using Zsh, back up any existing `~/.zshrc` before deploying the Zsh configuration:

```sh
stow -n -v --no-folding -t "$HOME" zsh
stow -v --no-folding -t "$HOME" zsh
```

Stow won't overwrite conflicting files. Review its output before applying changes.

## Notes

This setup has been tested on macOS. The Ghostty and Starship configurations are intended to be reusable on Linux, but I haven't deployed them there yet. There's no automatic package installer or bootstrap script at this point.
