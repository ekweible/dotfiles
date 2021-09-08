#!/usr/bin/env bash

set -e

source $DOTFILES/lib_sh/echos.sh

git config user.name evanweible-wf
git config user.email evan.weible@workiva.com
git config user.signingkey 8C997CA8F29161D2

ok "$(git config user.name) <$(git config user.email)> (signingkey: $(git config user.signingkey))"

# TODO: automate this?
warn "Make sure your remote URLs are set to git@github.com-evanweible-wf:"
git remote -v
