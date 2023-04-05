#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."
DOTFILES="$(pwd)"

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Confirm the branch is correct
branch="$(git rev-parse --abbrev-ref HEAD)"
prompt "Bootstrapping from branch $CYAN$branch$NORMAL. Continue? (y/n)" -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warn "Aborted."
    exit 1
fi

# Make sure we're on latest
running "Pulling..."
git pull
running "Updating submodules..."
git submodule update --init --recursive

# Update Mac OS settings
running "Mac OS setup..."
$DOTFILES/bin/,macos.sh

# Install homebrew and use it to install dependencies and apps
running "Installing brew, deps, and apps..."
$DOTFILES/bin/,brew-bundle.sh

# Restore config files from the Mackup submodule
running "Restoring dotfiles via mackup..."
$DOTFILES/bin/,mackup-restore.sh

# Bootstrap asdf plugins and latest installations.
running "Bootstrapping asdf..."
$DOTFILES/bin/,asdf-bootstrap.sh

# Link shell config into home directory
running "Linking shell config files..."
$DOTFILES/bin/,link.sh

# Hand-off to private bootstrap, if available
[ -f $DOTFILES/private/bootstrap.sh ] && $DOTFILES/private/bootstrap.sh

ok "Done. Login to a new shell."
