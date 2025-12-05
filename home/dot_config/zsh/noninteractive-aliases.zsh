#!/usr/bin/env zsh
# Aliases for non-interactive shells
# These are sourced by .zshenv and are available in all shell contexts,
# including non-interactive shells like chat command prompts.

# === Core shortcuts ===
alias g="git"
alias p="pnpm"
alias ls='lsd'

# === Utility aliases ===
alias path='echo -e ${PATH//:/\\n}'
alias reload="exec $SHELL -l"

# Add more commonly-used aliases here that you want available
# in non-interactive contexts (like chat command prompts)
