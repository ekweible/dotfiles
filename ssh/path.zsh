# Start ssh-agent, but only if needed
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
fi

# List of private key files
private_key_files=(~/.ssh/*.id_ed25519)

# List of key fingerprints currently loaded in the SSH agent
loaded_key_fingerprints=$(ssh-add -l -E md5 | awk '{print $2}')

# Iterate through the private key files and add them with `ssh-add`, but only if
# they aren't already loaded in the session
for private_key in "${private_key_files[@]}"; do
    # Get the fingerprint of the private key
    key_fingerprint=$(ssh-keygen -E md5 -lf "${private_key}" | awk '{print $2}')

    # Check if the key fingerprint is already in the list of loaded key fingerprints
    if ! grep -qF -- "${key_fingerprint}" <<<"${loaded_key_fingerprints}"; then
        ssh-add --apple-use-keychain "${private_key}"
    fi
done
