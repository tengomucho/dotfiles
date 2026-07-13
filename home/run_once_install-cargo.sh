#!/bin/sh

set -e

if command -v cargo >/dev/null 2>&1  || [ -x "$HOME/.cargo/bin/cargo" ]; then
    echo "cargo already installed"
    exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
