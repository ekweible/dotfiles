#!/bin/bash

# For debugging.
# This should be identical to ~/.asdf/plugins/dart/tools/dart_version_watcher.sh,
# but with print statements.

set -o nounset                              # Treat unset variables as an error

fs_watch_instances=$(ps | grep "fswatch ${HOME}/.tool-versions" | wc -l | tr -d "[:blank:]")
echo "dart version watcher instances: $fs_watch_instances"

# verify we only have one watcher running
[ "$fs_watch_instances" -gt "1" ] && exit

echo "starting new dart version watcher"
fswatch ${HOME}/.tool-versions | while read event
do
    rm -f ${HOME}/.asdf_dart_sdk && ln -s $(asdf where dart)/dart-sdk ${HOME}/.asdf_dart_sdk
done &
