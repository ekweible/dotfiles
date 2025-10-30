#!/bin/bash
# Update dotfiles and packages

echo "📦 Updating Homebrew packages..."
brew upgrade
brew cleanup

echo "🔄 Updating chezmoi dotfiles..."
chezmoi update

echo "✅ All updates complete"
