#!/bin/sh

set -e

if command -v uv >/dev/null 2>&1 || [ -x "$HOME/.local/bin/uv" ]; then
    echo "uv already installed"
    exit 0
fi

curl -LsSf https://astral.sh/uv/install.sh | sh
