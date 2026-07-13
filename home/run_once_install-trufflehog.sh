#!/bin/sh

set -e

if command -v trufflehog >/dev/null 2>&1 || [ -x "$HOME/.local/bin/trufflehog" ]; then
    echo "trufflehog already installed"
    exit 0
fi

mkdir -p "$HOME/.local/bin"
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b "$HOME/.local/bin"
