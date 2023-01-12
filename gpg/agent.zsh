if command -v gpg-agent &> /dev/null; then
    if [ -z "$(pgrep gpg-agent)" ]; then
        eval $(gpg-agent --daemon)
    fi
fi
