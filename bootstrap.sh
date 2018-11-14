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

# replace Mac python with brew python
python3_bin=$(which python3) 2>&1 > /dev/null
if [[ $? != 0 ]]
then
  running "installing python"
  require_brew "python@3"
else
  ok "python3 already installed"
fi

# install virtualenvwrapper
if [ ! -f /usr/local/bin/virtualenvwrapper.sh ]
then
  running "installing virtualenvwrapper"
  run_command "pip3 install virtualenvwrapper"
else
  ok "virtualenvwrapper already installed"
fi

# configure virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev

source /usr/local/bin/virtualenvwrapper.sh

# create dotfiles virtualenv if one does not eist
if [ ! -d $HOME/.virtualenvs/dotfiles ]
then
  running "creating virtualenv for dotfiles tooling"
  run_command "mkvirtualenv dotfiles"
fi

running "installing python dependencies and switching to python bootstrap script"
source $HOME/.virtualenvs/dotfiles/bin/activate \
  && cd pydotfiles && pip3 install -r requirements.txt > pip_install_stdout.txt && rm pip_install_stdout.txt && cd - \
  && python pydotfiles/pydotfiles/bin/bootstrap.py
