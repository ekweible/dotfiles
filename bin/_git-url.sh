#!/usr/bin/env bash

set -e

host=$1
repo=$2

echo $host:$(_git-repo.sh $repo)
