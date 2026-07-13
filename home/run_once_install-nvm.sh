#!/bin/sh

set -e

export NVM_DIR="$HOME/.config/nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "nvm already installed"
    exit 0
fi

rm -f "$HOME/.npmrc"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

. "$NVM_DIR/nvm.sh"
nvm install 24
