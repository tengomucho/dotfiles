#!/bin/sh

set -e

if command -v atuin >/dev/null 2>&1 || [ -x "$HOME/.atuin/bin/atuin" ]; then
    echo "atuin already installed"
    exit 0
fi

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive


# If $SHELL is bash, set rc to .bashrc, else if $SHELL is zsh, set rc to .zshrc, otherwise do nothing
case "$SHELL" in
    */bash)
        shell=bash
        rc="$HOME/.bashrc"
        ;;
    */zsh)
        shell=zsh
        rc="$HOME/.zshrc"
        ;;
    *)
        rc=""
        ;;
esac

# Disable atuin's up-arrow history search in favor of the default shell behavior
if [ -f "$rc" ]; then
    if grep -q "atuin init" "$rc"; then
        sed "s|^eval \"\$(atuin init $shell)\"\$|eval \"\$(atuin init $shell --disable-up-arrow)\"|" "$rc" > "$rc.tmp" && mv "$rc.tmp" "$rc"
    else
        echo "eval \"\$(atuin init $shell --disable-up-arrow)\"" >> "$rc"
    fi
fi