#!/usr/bin/env bash

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

running "brew upgrade"
brew upgrade
running "brew upgrade --cask --greedy"
brew upgrade --cask --greedy

ok
