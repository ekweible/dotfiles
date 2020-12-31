# UNCOMMENT TO PROFILE ZSH STARTUP TIME
# zmodload zsh/zprof

# === ZPLUG ===
# https://github.com/zplug/zplug
source $HOME/dev/dotfiles/submodules/zplug/init.zsh

# === PLUGINS ===

zplug "plugins/z", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "lukechilds/zsh-nvm"

# zsh-syntax-highlighting must be loaded after executing compinit command and
# sourcing other plugins
# (If the defer tag is given 2 or above, it runs after compinit command)
# zplug "zsh-users/zsh-highlighting", from:github, defer:2

# === THEME ===

[[ ! -f ~/dev/dotfiles/zsh_local/p10k.zsh ]] || source ~/dev/dotfiles/zsh_local/p10k.zsh
zplug romkatv/powerlevel10k, as:theme, depth:1

# === OPTIONS ===

unsetopt correct # disable zsh autocorrect
export CASE_SENSITIVE="true" # case-sensitive completion
export DISABLE_AUTO_TITLE="true"
export DISABLE_LS_COLORS="true"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# === ZPLUG ===
# Source plugins and add commands to $PATH
zplug load # --verbose

# UNCOMMENT TO PROFILE ZSH STARTUP TIME
# zprof
