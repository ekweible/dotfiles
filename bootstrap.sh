#!/usr/bin/env bash

# Include library helpers for colorized echo and require_brew, etc
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh
source ./lib_sh/requirers.sh
source ./lib_sh/runner.sh

export DOTFILES="$HOME/dev/dotfiles"
export HOMEDIR="$DOTFILES/homedir"

brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]
then
  running "installing homebrew"
  run_command "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\""

  if [[ $? != 0 ]]
  then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  ok "homebrew already installed"
fi

require_brew "pyenv"
require_brew "pyenv-virtualenv"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# create dotfiles virtualenv if one does not eist
if [ ! -d "$(pyenv root)/versions/dotfiles" ]
then
  running "creating virtualenv for dotfiles tooling"
  run_command "pyenv virtualenv 3.9.4 dotfiles"
fi

running "installing python dependencies and switching to python bootstrap script"
eval "$(pyenv init -)" \
  && eval "$(pyenv virtualenv-init -)" \
  && pyenv activate dotfiles \
  && cd pydotfiles \
  && pip install -r requirements.txt > pip_install_stdout.txt && rm pip_install_stdout.txt && cd - \
  && python pydotfiles/pydotfiles/bin/bootstrap.py
