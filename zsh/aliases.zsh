# reload changes to dotfiles
alias reload!='. ~/.zshrc'

# basic aliases
alias cl='clear'

# workspaces
alias dev='cd ~/dev'
alias devconf='cd ~/dev/config'
alias devekw='cd ~/dev/ekweible'
alias devwf='cd ~/dev/wf'

# projects
alias dotfiles='cd ~/dev/config/dotfiles'
alias home='cd ~/dev/wf/wf-home-html'
alias ra='cd ~/dev/wf/richapps'
alias sky='cd ~/dev/wf/bigsky'
alias wb='cd ~/dev/wf/web-bones'
alias wfjsv='cd ~/dev/wf/wf-js-vendor'

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
function run() {
    python ~/dev/wf/scripts/runserver.py "`pwd`" "$@"
}