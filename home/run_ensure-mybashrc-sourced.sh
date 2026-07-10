#!/bin/sh

set -e

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$rc" ] && grep -q "mybashrc" "$rc"; then
    continue
  fi
  echo "source ~/.mybashrc" >> "$rc"
done
