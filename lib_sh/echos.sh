#!/usr/bin/env bash

###
# some colorized echo helpers
# @author Adam Eivy
###

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function br() {
  printf "\n"
}

function ok() {
  echo -e "$COL_GREEN[ok]$COL_RESET "$1
}

function bot() {
  echo -e "\n$COL_GREEN\[._.]/$COL_RESET - "$1
}

function group() {
    echo -e "\n$COL_YELLOW[-----]$COL_RESET $1\n"
}

function prompt() {
  read -r -p $'\x1b[32;01m?\x1b[39;49;00m'" $1 " response
  echo $response
}

function running() {
  echo -en "$COL_YELLOW ⇒ $COL_RESET$1 "
}

function warn() {
  echo -e "$COL_YELLOW[warning]$COL_RESET "$1
}

function error() {
  echo -e "$COL_RED[error]$COL_RESET "$1
}
