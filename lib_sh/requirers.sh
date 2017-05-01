#!/usr/bin/env bash

###
# convienience methods for requiring installed software
# @author Adam Eivy
###

# source ./echos.sh
# source ./runner.sh

function require_cask() {
  brew cask list $1 > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]
  then
    running "installing cask $1 $2"
    run_command "brew cask install $1"

    # brew cask install $1 2>&1 > /dev/null
    # if [[ $? != 0 ]]; then
    #   error "failed to install $1! aborting"
    #   # exit -1
    # fi
  else
    running "cask $1 already installed"
    ok
  fi
}

function require_brew() {
  brew list $1 > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]
  then
    running "brew install $1 $2"
    run_command "brew install $1 $2"

    # brew install $1 $2
    # if [[ $? != 0 ]]; then
    #   error "failed to install $1! aborting"
    #   # exit -1
    # fi
  else
    running "package $1 already installed"
    ok
  fi
}

function require_node() {
  node -v 2>&1 > /dev/null
  if [[ $? != 0 ]]
  then
    require_brew node
  else
    running "node already installed"
  fi
  ok
}

# function require_npm() {
#     source_nvm
#     nvm use 4.4.4
#     running "requiring npm"
#     npm list -g --depth 0 | grep $1@ > /dev/null
#     if [[ $? != 0 ]]; then
#         action "npm install -g $*"
#         npm install -g $@
#     fi
#     ok
# }

function source_nvm() {
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
}

function require_nvm() {
#   . ~/.bashrc
  mkdir -p ~/.nvm
  cp $(brew --prefix nvm)/nvm-exec ~/.nvm/
  source_nvm
  running "requiring nvm $1"
  run_command "nvm install $1"
}
