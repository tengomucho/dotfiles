#!/bin/sh

set -e

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

# initialize chezmoi's source dir from this repo and apply the managed dotfiles
if command -v chezmoi >/dev/null 2>&1; then
  chezmoi init --apply tengomucho
else
  echo "chezmoi installation failed, skipping chezmoi-managed files"
fi

