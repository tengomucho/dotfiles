#!/bin/sh

set -e

if command -v hf >/dev/null 2>&1 || [ -x "$HOME/.local/bin/hf" ]; then
    echo "hf already installed"
    exit 0
fi

# uv (installed by run_once_install-astral-uv.sh into ~/.local/bin) may not
# be on PATH yet during chezmoi's run_once pass, so add it explicitly.
if ! command -v uv >/dev/null 2>&1 && [ -x "$HOME/.local/bin/uv" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Use uv tool install instead of the official hf.co installer: uv creates an
# isolated environment without ensurepip, so it works on Debian/Ubuntu without
# the python3-venv package that `python3 -m venv` requires.
uv tool install huggingface_hub
