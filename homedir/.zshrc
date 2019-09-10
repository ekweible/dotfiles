# Path to your oh-my-zsh configuration.
export ZSH=$HOME/dev/dotfiles/oh-my-zsh

# ==============================================================================
# Config
# ==============================================================================

export TERM="xterm-256color"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# disable autosetting terminal title.
export DISABLE_AUTO_TITLE="true"

# ==============================================================================
# Theme
# ==============================================================================

export ZSH_THEME="evanweible/minimal"

# https://github.com/bhilburn/powerlevel9k#customizing-prompt-segments
# https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt
# export ZSH_THEME="powerlevel9k/powerlevel9k"
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=()
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
# POWERLEVEL9K_SHOW_CHANGESET=true

# ==============================================================================
# Plugins
# ==============================================================================

# Plugins are found in:
#   ~/dev/dotfiles/oh-my-zsh/plugins/
#   ~/dev/dotfiles/oh-my-zsh/custom/plugins/
# NOTE: zsh-syntax-highlighting must be sourced last
plugins=(cp git history zsh-autosuggestions zsh-syntax-highlighting)

# ==============================================================================
# iTerm2
# ==============================================================================

# To regenerated this script:
#   iTerm2 > Install Shell Integration > navigate to zsh source and copy/paste
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# See https://www.iterm2.com/3.3/documentation-scripting-fundamentals.html
function iterm2_print_user_vars() {
  iterm2_set_user_var dartVersion $(dart --version 2>&1 | grep -oe "\d*\.\d*\.\d*[^ ]*")
  iterm2_set_user_var nodeVersion $(node -v)
  iterm2_set_user_var pwd $(pwd)
}

# ==============================================================================
# ???
# ==============================================================================

# What does this do?
unsetopt correct

# Uncomment for a colorcode test:
# for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"

# ==============================================================================
# oh-my-zsh
# ==============================================================================

source $ZSH/oh-my-zsh.sh
