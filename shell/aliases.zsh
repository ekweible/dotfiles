# cd
alias dev="cd ~/dev/"
alias dotfiles="cd $DOTFILES"

# programs
alias code="code-insiders"
alias g="git"
alias ls='exa --all --long --header'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"
