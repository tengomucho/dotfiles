#!/bin/sh

set -e

# directory where this script is located
DIR=`dirname "$BASH_SOURCE"`
DIR=`realpath $DIR`

# chezmoi-managed files (see home/, .chezmoiroot)
if command -v chezmoi >/dev/null 2>&1; then
  chezmoi apply --source "$DIR"
else
  echo "chezmoi not installed, skipping chezmoi-managed files"
fi

