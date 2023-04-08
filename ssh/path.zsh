# Start ssh-agent and load SSH key
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
fi

ssh-add --apple-use-keychain ~/.ssh/*.id_ed25519
