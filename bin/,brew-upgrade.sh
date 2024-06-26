#!/usr/bin/env bash

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Run this first to ensure brew and all declared deps are installed
./bin/,brew-bundle.sh

running "brew upgrade"
brew upgrade
running "brew upgrade --cask --greedy"
brew upgrade --cask --greedy

# Run this again to update the Brewfile.lock.json
./bin/,brew-bundle.sh

ok
