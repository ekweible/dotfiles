#!/usr/bin/env bash

set -e

source $DOTFILES/lib_sh/echos.sh

git config user.name ekweible
git config user.email ekweible@gmail.com
git config user.signingkey 294B94D56CF30407

ok "$(git config user.name) <$(git config user.email)> (signingkey: $(git config user.signingkey))"

# TODO: automate this?
warn "Make sure your remote URLs are set to git@github.com-ekweible:"
git remote -v
