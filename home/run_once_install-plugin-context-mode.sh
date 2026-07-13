#!/bin/sh

set -e

export NVM_DIR="$HOME/.config/nvm"
. "$NVM_DIR/nvm.sh"

if claude plugin list 2>/dev/null | grep -q "context-mode@context-mode"; then
    echo "context-mode already installed"
    exit 0
fi

claude plugin marketplace add mksglu/context-mode
claude plugin install context-mode@context-mode
