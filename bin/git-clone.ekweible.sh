#!/usr/bin/env bash

set -e

source _git-clone.sh git@github.com-ekweible $@
source git-config-signingkey.ekweible.sh
