# To regenerated this script:
#   iTerm2 > Install Shell Integration > navigate to zsh source and copy/paste
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# See https://www.iterm2.com/3.3/documentation-scripting-fundamentals.html
function iterm2_print_user_vars() {
  iterm2_set_user_var pwd $(pwd)
  iterm2_set_user_var dartVersion $(dart --version 2>&1 | grep -oe "\d*\.\d*\.\d*[^ ]*")
  if command -v node ; then
    iterm2_set_user_var nodeVersion $(node -v)
  fi
  iterm2_set_user_var pyVersion $(python --version 2>&1 | grep -oe "\d*\.\d*\.\d*[^ ]*")
  if [ -n "$VIRTUAL_ENV" ]; then
    iterm2_set_user_var pyVenv "($(basename "$VIRTUAL_ENV"))"
  fi
}

# Customize tab title to be the current project name:
# See https://gist.github.com/phette23/5270658#gistcomment-3020766
export DISABLE_AUTO_TITLE="true"
precmd() {
  echo -ne "\033]0;$(basename $(get_dir_or_repo_root))\007"
}
