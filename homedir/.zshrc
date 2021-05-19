# UNCOMMENT TO PROFILE ZSH STARTUP TIME
# zmodload zsh/zprof

# === Shell-agnostic config ===
source ~/.profile

# === History Configuration ===
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed


# === ZPLUG SETUP ===
# https://github.com/zplug/zplug
source $HOME/dev/dotfiles/submodules/zplug/init.zsh
zplug "plugins/asdf", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/enhancd", use:init.sh

# === THEME ===
[[ ! -f ~/dev/dotfiles/zsh_local/p10k.zsh ]] || source ~/dev/dotfiles/zsh_local/p10k.zsh
zplug romkatv/powerlevel10k, as:theme, depth:1

# === OPTIONS ===
unsetopt correct # disable zsh autocorrect
export CASE_SENSITIVE="true" # case-sensitive completion
export DISABLE_AUTO_TITLE="true"
export DISABLE_LS_COLORS="true"
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true" # zsh-history-substring-search

# === KEYBINDS ===
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# === ZPLUG LOAD ===
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
# Source plugins and add commands to $PATH
zplug load # --verbose

# UNCOMMENT TO PROFILE ZSH STARTUP TIME
# zprof
