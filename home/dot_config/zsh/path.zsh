# === Path configurations ===
# Consolidated from all modules for easier management

# === asdf ===
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# === bun ===
export BUN_INSTALL=$HOME/.bun
export PATH=$PATH:$BUN_INSTALL/bin

# === dart ===
# Globally activated Dart packages
export PATH=$PATH:~/.pub-cache/bin

# Enable testing of local Dart builds
# https://github.com/dart-lang/sdk/wiki/Building#mac-os-x
export LOCAL_DART_SDK_BIN=$HOME/dev/dart-lang/sdk/sdk/bin
export PATH=$PATH:$HOME/dev/dart-lang/depot_tools

# === docker ===
export PATH=$PATH:~/.docker/bin

# === golang ===
export GOPATH=$HOME/dev/go
export GOPRIVATE=github.com/Workiva
export GOPROXY=""
export PATH=$PATH:$GOPATH/bin

# === gpg ===
# https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/telling-git-about-your-signing-key
export GPG_TTY=$(tty)

# === intellij ===
export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"

# === iterm2 ===
export TERM="xterm-256color"

# === java ===
source ~/.asdf/plugins/java/set-java-home.zsh

# === pnpm ===
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# === python ===
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(command pyenv virtualenv-init -)"

# === ssh ===
# Start ssh-agent, but only if needed
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
fi

# List of private key files
private_key_files=(~/.ssh/*id_ed25519)

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
