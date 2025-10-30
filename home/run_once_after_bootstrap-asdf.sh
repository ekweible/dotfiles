#!/bin/bash
# Runs once after initial apply

if ! command -v asdf &> /dev/null; then
    echo "⚠️  asdf not found, skipping..."
    exit 0
fi

echo "🔧 Bootstrapping asdf plugins and runtimes..."

# Add plugins (suppress errors if already exist)
asdf plugin add bun 2>/dev/null || true
asdf plugin add dart https://github.com/patoconnor43/asdf-dart.git 2>/dev/null || true
asdf plugin add golang https://github.com/kennyp/asdf-golang.git 2>/dev/null || true
asdf plugin add java https://github.com/halcyon/asdf-java.git 2>/dev/null || true
asdf plugin add kotlin 2>/dev/null || true
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
asdf plugin update --all

# Install latest versions
for tool in bun dart golang nodejs; do
    echo "Installing $tool..."
    asdf install $tool latest 2>/dev/null || true
done

# Java (specific version)
echo "Installing java openjdk-21..."
asdf install java openjdk-21 2>/dev/null || true

echo "✅ asdf bootstrap complete"
