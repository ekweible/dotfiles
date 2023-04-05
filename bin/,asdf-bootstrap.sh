#!/usr/bin/env bash

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/brew.sh
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# During initial bootstrap, brew env may need to be setup for this shell session
setup_brew_env_if_missing

asdf plugin-add dart https://github.com/patoconnor43/asdf-dart.git
asdf plugin-add flutter
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf plugin add kotlin
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin update --all

asdf install latest dart
asdf install latest flutter
asdf install latest golang
asdf install latest nodejs

# note: we don't install latest of java because there are several different
# distributions and therefore no definitive latest
