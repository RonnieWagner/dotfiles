# Shared Zsh configuration
# Managed by GNU Stow

# Load machine-specific environment first
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Homebrew-based shell enhancements
if command -v brew >/dev/null 2>&1; then
    ZSH_BREW_PREFIX="$(brew --prefix)"

    # Interactive command suggestions
    if [[ -f "$ZSH_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        source "$ZSH_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi
fi

# Initialize Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Load syntax highlighting last
if [[ -n "${ZSH_BREW_PREFIX:-}" ]]; then
    if [[ -f "$ZSH_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        source "$ZSH_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi
fi
unset ZSH_BREW_PREFIX
