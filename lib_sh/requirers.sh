#!/usr/bin/env bash

###
# convienience methods for requiring installed software
# @author Adam Eivy
###

function require_brew() {
  brew list $1 > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]
  then
    running "brew install $1 $2"
    run_command "brew install $1 $2"
  else
    running "package $1 already installed"
    ok
  fi
}
