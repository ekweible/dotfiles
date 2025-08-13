#!/usr/bin/env zsh
# Sourced by zsh for every interactive zsh shell after .zprofile

# UNCOMMENT TO PROFILE ZSH STARTUP TIME
# zmodload zsh/zprof
# Also see https://github.com/romkatv/zsh-bench for benchmarking

# all zsh files
typeset -U config_files
config_files=($DOTFILES/*/*.zsh)

################################################################################
# PHASE 1: path.zsh files
################################################################################

# load brew path first, since others may depend on it
source "$DOTFILES/brew.path.zsh"

# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

################################################################################
# PHASE 2: *.zsh files (except completion.zsh)
################################################################################

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

################################################################################
# PHASE 3: Zsh plugins (install and compile)
################################################################################

# Zsh "plugin manager"
function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Clone and compile to wordcode missing plugins.
if [[ ! -e ~/zsh-plugins ]]; then
  mkdir ~/zsh-plugins
fi
if [[ ! -e ~/zsh-plugins/zsh-syntax-highlighting ]]; then
  if git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-plugins/zsh-syntax-highlighting; then
    zcompile-many ~/zsh-plugins/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
  else
    echo "Warning: Failed to install zsh-syntax-highlighting"
  fi
fi
if [[ ! -e ~/zsh-plugins/zsh-autosuggestions ]]; then
  if git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/zsh-plugins/zsh-autosuggestions; then
    zcompile-many ~/zsh-plugins/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
  else
    echo "Warning: Failed to install zsh-autosuggestions"
  fi
fi
if [[ ! -e ~/zsh-plugins/zsh-history-substring-search ]]; then
  if git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git ~/zsh-plugins/zsh-history-substring-search; then
    zcompile-many ~/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  else
    echo "Warning: Failed to install zsh-history-substring-search"
  fi
fi
if [[ ! -e ~/zsh-plugins/zsh-z ]]; then
  if git clone --depth=1 https://github.com/agkozak/zsh-z.git ~/zsh-plugins/zsh-z; then
    zcompile-many ~/zsh-plugins/zsh-z/zsh-z.plugin.zsh
  else
    echo "Warning: Failed to install zsh-z"
  fi
fi

################################################################################
# PHASE 4: Enable zsh completion
################################################################################

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile-many ~/.zcompdump
unfunction zcompile-many

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

################################################################################
# PHASE 5: Zsh plugins (load)
################################################################################

# Load plugins.
source ~/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/zsh-plugins/zsh-z/zsh-z.plugin.zsh

################################################################################
# PHASE 6: completion.zsh files
################################################################################

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files

# ==============================================================================
# History
# ==============================================================================\
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt    histignorespace   #Don't add commands that start with space to history

# ==============================================================================
# Misc options
# ==============================================================================\
unsetopt correct # disable zsh autocorrect
export CASE_SENSITIVE="true" # case-sensitive completion
export DISABLE_AUTO_TITLE="true"
export DISABLE_LS_COLORS="true"
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true" # zsh-history-substring-search

# ==============================================================================
# Keybinds
# ==============================================================================\
# Use vim cli mode
bindkey -v

# Iterate through command history
bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# UNCOMMENT TO PROFILE ZSH STARTUP TIME
# zprof

################################################################################
# PHASE 7: Prompt
################################################################################

eval "$(starship init zsh)"
