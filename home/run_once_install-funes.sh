#!/bin/sh

set -e

if command -v funes >/dev/null 2>&1 || [ -x "$HOME/.local/bin/funes" ]; then
    echo "funes already installed"
else
    curl -fsSL https://huggingface.co/buckets/huggingface/funes/resolve/install.sh | sh
fi

mkdir -p "$HOME/.claude/hooks"

curl -fsSL https://raw.githubusercontent.com/huggingface/funes/main/scripts/automation/funes-index.sh \
    -o "$HOME/.claude/hooks/funes-index.sh"
curl -fsSL https://raw.githubusercontent.com/huggingface/funes/main/scripts/automation/funes-push.sh \
    -o "$HOME/.claude/hooks/funes-push.sh"

chmod +x "$HOME/.claude/hooks/funes-index.sh" "$HOME/.claude/hooks/funes-push.sh"

ubuntu_2204=0
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if { [ "$ID" = "ubuntu" ] || printf '%s' "${ID_LIKE:-}" | grep -qw ubuntu; } && [ "$VERSION_ID" = "22.04" ]; then
        ubuntu_2204=1
    fi
fi

if [ "$ubuntu_2204" = "1" ]; then
    if [ -x "$HOME/.bin/patch_funes.sh" ]; then
        echo "Ubuntu 22.04 detected: patching funes for older glibc"
        "$HOME/.bin/patch_funes.sh" --install
    else
        echo "Ubuntu 22.04 detected but $HOME/.bin/patch_funes.sh not found; skipping glibc patch" >&2
    fi
fi

echo "funes hooks installed. One-time manual steps still needed on this machine:"
echo "  1. funes index                # build the local store (interactive, first time only)"
echo "  2. funes use <org>/<repo>      # attach a shared store (optional)"
echo "  3. funes push <org>/<repo>     # first push, by hand (only if using a shared store)"
