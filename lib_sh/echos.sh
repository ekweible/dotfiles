#!/usr/bin/env bash

###
# some colorized echo helpers
# @author Adam Eivy
###

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

function br() {
  printf "\n"
}

function ok() {
  printf "%s\n" "$GREEN[ok]$NORMAL $1"
}

function bot() {
  printf "\n%s\n" "$GREEN\[._.]/$NORMAL - $1"
}

function group() {
  printf "\n%s\n\n" "$YELLOW[-----]$NORMAL $1"
}

function prompt() {
  read -p $'\x1b[32;01m?\x1b[39;49;00m'" $1 " "${@:2}"
}

function running() {
  printf "%s\n" "$YELLOW ⇒ $NORMAL$1"
}

function warn() {
  printf "%s\n" "$YELLOW[warning]$NORMAL $1"
}

function error() {
  printf "%s\n" "$RED[error]$NORMAL $1"
}
