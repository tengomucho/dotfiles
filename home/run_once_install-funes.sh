#!/bin/sh

set -e

if command -v funes >/dev/null 2>&1 || [ -x "$HOME/.local/bin/funes" ]; then
    echo "funes already installed"
else
    curl -fsSL https://huggingface.co/buckets/huggingface/funes/resolve/install.sh | sh
fi

echo "funes hooks installed. One-time manual steps still needed on this machine:"
echo "  1. funes index                         # build the local store (interactive, first time only)"
echo "  2. funes add <agent> <org>/<repo>      # attach a shared store (optional)"
echo "  3. funes push <org>/<repo>             # first push, by hand (only if using a shared store)"
