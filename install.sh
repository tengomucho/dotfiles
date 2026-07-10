#!/bin/sh

set -e

# directory where this script is located
DIR=`dirname "$BASH_SOURCE"`
DIR=`realpath $DIR`

# install chezmoi if missing
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "chezmoi not found, installing..."
  if command -v brew >/dev/null 2>&1; then
    brew install chezmoi
  else
    mkdir -p "$HOME/.local/bin"
    BINDIR="$HOME/.local/bin" sh -c "$(curl -fsLS https://get.chezmoi.io)"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

# chezmoi-managed files (see home/, .chezmoiroot)
if command -v chezmoi >/dev/null 2>&1; then
  chezmoi apply --source "$DIR"
else
  echo "chezmoi installation failed, skipping chezmoi-managed files"
fi

