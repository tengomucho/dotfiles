#!/bin/sh

set -e

export NVM_DIR="$HOME/.config/nvm"
. "$NVM_DIR/nvm.sh"

if command -v pi >/dev/null 2>&1; then
    echo "pi already installed"
    exit 0
fi

npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# This is required for pi-memory to work
npm install -g @tobilu/qmd
