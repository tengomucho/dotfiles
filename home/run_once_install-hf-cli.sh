#!/bin/sh

set -e

if command -v hf >/dev/null 2>&1 || [ -x "$HOME/.local/bin/hf" ]; then
    echo "hf already installed"
    exit 0
fi

curl -LsSf https://hf.co/cli/install.sh | bash
