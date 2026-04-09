# === Path configurations ===
# Consolidated from all modules for easier management

# === asdf ===
# NOTE: asdf shims are added to PATH at the END of this file to ensure
# asdf-managed tools take priority over brew-installed versions.
export ASDF_DATA_DIR="$HOME/.asdf"

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

# === obsidian ===
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# === iterm2 ===
export TERM="xterm-256color"

# === java ===
source ~/.asdf/plugins/java/set-java-home.zsh

# === npm ===
# Global packages installed via `npm install -g`
# Requires: npm config set prefix ~/.npm-global
export PATH="$HOME/.npm-global/bin:$PATH"

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
# On macOS, prefer the launchd-provided agent so Keychain-backed keys survive reboots.
if [[ -o interactive ]] && [[ -z "$SSH_TTY" ]] && [[ -z "$SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK="$(launchctl getenv SSH_AUTH_SOCK)"
fi
