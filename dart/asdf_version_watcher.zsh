# Start the global version watcher from the asdf-dart plugin.
# https://github.com/PatOConnor43/asdf-dart#using-in-your-favorite-ideeditor
[ -d $HOME/.asdf/plugins/dart ] && bash $HOME/.asdf/plugins/dart/tools/dart_version_watcher.sh > /dev/null
