# Environment variables
export DOTFILES="$HOME/.config/dotfiles"

# Preferred editor hierarchy
if command -v zed &> /dev/null; then
    export EDITOR="zed"
elif command -v cursor &> /dev/null; then
    export EDITOR="cursor"
elif command -v code &> /dev/null; then
    export EDITOR="code"
else
    export EDITOR="vi"
fi

# Browser
export BROWSER="open"
