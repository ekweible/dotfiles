#!/usr/bin/env bash

# source ./echos.sh

function run_command() {
  local cmd="$1"
  eval "$cmd" >cmd_output.txt 2>&1
  if [[ $? != 0 ]]
  then
    error "\n\n  command: $cmd\n  exit code: $?\n  output:\n\n$(cat cmd_output.txt)"
    rm cmd_output.txt
    exit 1
  else
    rm cmd_output.txt
    ok
  fi
}
