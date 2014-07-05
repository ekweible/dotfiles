# reload changes to dotfiles
alias reload!='. ~/.zshrc'

# basic aliases
alias cl='clear'

# workspaces
alias dev='cd ~/dev/ekweible'
alias devconf='cd ~/dev/config'

# projects
alias alfred='cd ~/dev/ekweible/alfred-workflows'
alias deca='cd ~/dev/ekweible/iadeca'
alias dotfiles='cd ~/dev/config/dotfiles'
alias ekw='cd ~/dev/ekweible/ekweible.github.io'
alias fpm='cd ~/dev/ekweible/fpm'
alias iadeca='deca'
alias portfolio='ekw'
alias secrets='cd ~/dev/config/secrets'

# check for virtualenv upon entering directories
has_virtualenv() {
    if [ -e .venv ]; then
        workon `cat .venv`
    fi
}
venv_cd () {
    builtin cd "$@" && has_virtualenv
}
alias cd="venv_cd"

# gae aliases
#function run() {
#    python ~/dev/ekweible/scripts/runserver.py "`pwd`" "$@"
#}