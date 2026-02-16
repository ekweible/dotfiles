#!/bin/bash
# Runs once after initial apply to install opencode via direct install method
# Previously installed via brew, now using: curl -fsSL https://opencode.ai/install | bash

set -e

# Check if already installed
if command -v opencode &>/dev/null; then
	echo "✅ opencode already installed"
	exit 0
fi

echo "📦 Installing opencode..."
curl -fsSL https://opencode.ai/install | bash

echo "✅ opencode installation complete"
