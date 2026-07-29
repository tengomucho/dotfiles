#!/bin/sh

set -e

if command -v atuin >/dev/null 2>&1 || [ -x "$HOME/.atuin/bin/atuin" ]; then
    echo "atuin already installed"
    exit 0
fi

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive

# Disable atuin's up-arrow history search in favor of the default shell behavior
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    case "$rc" in
        *.bashrc) shell=bash ;;
        *.zshrc) shell=zsh ;;
    esac
    if [ -f "$rc" ]; then
        echo "👋 After atuin's installation, you might want to run this command"
        echo sed "s|^eval \"\$(atuin init $shell)\"\$|eval \"\$(atuin init $shell --disable-up-arrow)\"|" "$rc" > "$rc.tmp" && mv "$rc.tmp" "$rc"
    fi
done
