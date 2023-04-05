#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Confirm the branch is correct
branch="$(git rev-parse --abbrev-ref HEAD)"
prompt "Bootstrapping from branch '$branch'. Continue? (y/n)" -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warn "Aborted."
    exit 1
fi

# Make sure we're on latest
running "Pulling..."
git pull
running "Updating submodules..."
git submodule update --remote

# Update Mac OS settings
running "Mac OS setup..."
source ./bin/,macos.sh

# Install homebrew and use it to install dependencies and apps
running "Installing brew, deps, and apps..."
source ./bin/,brew-bundle.sh

# Restore config files from the Mackup submodule
source ./bin/,mackup-restore.sh

# Bootstrap asdf plugins and latest installations.
source ./bin/,asdf-bootstrap.sh

# Link shell config into home directory
source ./bin/,link.sh

# Hand-off to private bootstrap, if available
[ -f ./private/bootstrap.sh ] && source ./private/bootstrap.sh

ok "Done. Login to a new shell."
