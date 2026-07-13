#!/bin/sh

set -e

if command -v gh >/dev/null 2>&1 || [ -x "$HOME/.local/bin/gh" ]; then
    echo "gh already installed"
    exit 0
fi

case "$(uname -s)" in
    Darwin) os=macOS; ext=zip ;;
    Linux) os=linux; ext=tar.gz ;;
    *) echo "unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$(uname -m)" in
    x86_64) arch=amd64 ;;
    arm64|aarch64) arch=arm64 ;;
    *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

version=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')
if [ -z "$version" ]; then
    echo "could not determine latest gh version" >&2
    exit 1
fi

name="gh_${version}_${os}_${arch}"
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL -o "$tmpdir/gh.$ext" "https://github.com/cli/cli/releases/download/v${version}/${name}.${ext}"

if [ "$ext" = "zip" ]; then
    unzip -q "$tmpdir/gh.$ext" -d "$tmpdir"
else
    tar -xzf "$tmpdir/gh.$ext" -C "$tmpdir"
fi

mkdir -p "$HOME/.local/bin"
mv "$tmpdir/$name/bin/gh" "$HOME/.local/bin/gh"
chmod +x "$HOME/.local/bin/gh"

for shell in bash zsh; do
    rc="$HOME/.${shell}rc"
    completion="$HOME/.gh_completion.${shell}"
    "$HOME/.local/bin/gh" completion -s "$shell" > "$completion"
    if [ -f "$rc" ] && grep -q "gh_completion.${shell}" "$rc"; then
        continue
    fi
    echo "source ~/.gh_completion.${shell}" >> "$rc"
done
