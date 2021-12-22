#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Make sure we're on latest
running "Pulling..."
git pull origin main
running "Updating submodules..."
git submodule update --remote

# Configure the user options and remote url for these repos
source ./bin/git-config.ekweible.sh && git remote set-url origin git@github.com-ekweible:ekweible/dotfiles.git
(cd Mackup && source ../bin/git-config.ekweible.sh && git remote set-url origin git@github.com-ekweible:ekweible/Mackup.git)
(cd private && source ../bin/git-config.ekweible.sh && git remote set-url origin git@github.com-ekweible:ekweible/dotfiles_private.git)

# Update Mac OS settings
running "Mac OS setup..."
source ./bin/dotfiles-macos.sh

# Install homebrew and use it to install dependencies and apps
running "Installing brew, deps, and apps..."
source ./bin/dotfiles-brew-bundle.sh

# Restore config files from the Mackup submodule
source ./bin/dotfiles-mackup-restore.sh

# Bootstrap asdf plugins and latest installations.
source ./bin/dotfiles-asdf-bootstrap.sh

# Hand-off to private bootstrap, if available
[ -f ./private/bootstrap.sh ] && source ./private/bootstrap.sh

ok "Done. Login to a new shell. If you have not already, run `p10k configure`."
