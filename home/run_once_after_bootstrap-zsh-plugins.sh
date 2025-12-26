#!/bin/bash
# Runs once after initial apply to install zsh plugins
# This moves plugin installation out of the shell startup critical path

set -e

ZSH_PLUGINS_DIR="$HOME/zsh-plugins"

echo "🔌 Installing zsh plugins..."

# Create plugins directory
mkdir -p "$ZSH_PLUGINS_DIR"

# Function to install a plugin
install_plugin() {
    local name="$1"
    local repo="$2"
    local dir="$ZSH_PLUGINS_DIR/$name"

    if [[ -d "$dir" ]]; then
        echo "  ✅ $name already installed"
        return 0
    fi

    echo "  📦 Installing $name..."
    if git clone --depth=1 "$repo" "$dir" 2>/dev/null; then
        echo "  ✅ $name installed"
    else
        echo "  ⚠️  Failed to install $name (network issue?)"
        return 1
    fi
}

# Install plugins
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git" || true
install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git" || true
install_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search.git" || true
install_plugin "zsh-z" "https://github.com/agkozak/zsh-z.git" || true

# Compile plugins to wordcode for faster loading
echo "⚡ Compiling plugins..."
if command -v zsh &> /dev/null; then
    zsh -c '
        zcompile-many() {
            local f
            for f; do zcompile -R -- "$f".zwc "$f" 2>/dev/null; done
        }
        [[ -d ~/zsh-plugins/zsh-syntax-highlighting ]] && zcompile-many ~/zsh-plugins/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh} 2>/dev/null
        [[ -d ~/zsh-plugins/zsh-autosuggestions ]] && zcompile-many ~/zsh-plugins/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh} 2>/dev/null
        [[ -d ~/zsh-plugins/zsh-history-substring-search ]] && zcompile-many ~/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
        [[ -d ~/zsh-plugins/zsh-z ]] && zcompile-many ~/zsh-plugins/zsh-z/zsh-z.plugin.zsh 2>/dev/null
    ' || true
fi

echo "✅ zsh plugins bootstrap complete"
