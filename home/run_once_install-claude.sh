#!/bin/sh

set -e

if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
    echo "claude already installed"
    exit 0
fi

curl -fsSL https://claude.ai/install.sh | bash
