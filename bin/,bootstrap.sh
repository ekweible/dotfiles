#!/usr/bin/env bash

set -e

# Allows this script to be run from anywhere
cd "$(dirname "${BASH_SOURCE}")/.."
DOTFILES="$(pwd)"
DOTFILES_PRIVATE="$DOTFILES/../dotfiles_private"
DOTFILES_PROFILE="$DOTFILES/../dotfiles_profile"

# Source some utils
source ./lib_sh/echos.sh
source ./lib_sh/linkers.sh

# Confirm the branch is correct
dotfiles_branch="$(git rev-parse --abbrev-ref HEAD)"
dotfiles_private_branch="$(cd ../dotfiles_private && git rev-parse --abbrev-ref HEAD)"
dotfiles_profile_branch="$(cd ../dotfiles_profile && git rev-parse --abbrev-ref HEAD)"
prompt "Bootstrapping from dotfiles/dotfiles_private/dotfiles_profile branches $CYAN$dotfiles_branch$NORMAL/$CYAN$dotfiles_private_branch$NORMAL/$CYAN$dotfiles_profile_branch$NORMAL. Continue? (y/n)" -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warn "Aborted."
    exit 1
fi

# Make sure we're on latest
running "Pulling..."
git pull

# Update Mac OS settings
running "Mac OS setup..."
$DOTFILES/bin/,macos.sh

# Install homebrew and use it to install dependencies and apps
running "Installing brew, deps, and apps..."
$DOTFILES/bin/,brew-bundle.sh

# Restore config files from the Mackup submodule
running "Restoring dotfiles via mackup..."
$DOTFILES/bin/,restore.sh

# Bootstrap asdf plugins and latest installations.
running "Bootstrapping asdf..."
$DOTFILES/bin/,asdf-bootstrap.sh

# Link shell config into home directory
running "Linking shell config files..."
$DOTFILES/bin/,link.sh

# Hand-off to private bootstrap, if available
[ -f $DOTFILES_PRIVATE/bootstrap.sh ] && $DOTFILES_PRIVATE/bootstrap.sh
# Hand-off to profile bootstrap, if available
[ -f $DOTFILES_PROFILE/bootstrap.sh ] && $DOTFILES_PROFILE/bootstrap.sh

ok "Done. Login to a new shell."
