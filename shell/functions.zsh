dotfiles() {
  if command -v cursor &> /dev/null; then
    editor="cursor"
  else
    editor="code"
  fi
  $editor ~/dev/workspaces/dotfiles.code-workspace
}

function pwd_last_two_segments() {
    PWD=$(pwd)
    if [ "$PWD" = "$HOME" ]; then
        echo "~"
    return
    fi

    D1=$(basename $(dirname "$PWD"))
    D2=$(basename "$PWD")
    if [ "$D2" = "/" ]; then
        echo "/"
    elif [ "$D1" = "/" ]; then
        echo "/$D2"
    else
        echo "$D1/$D2"
    fi
}
