#!/bin/sh

# Few notes on packages installable in a Debian/Ubuntu environment

# Many development packages, vim, python and clang.
sudo apt-get install vim-gtk cscope exuberant-ctags \
	uncrustify tmux build-essential cmake python3-dev \
	clang curl libpython-dev

# Maybe these too
sudo snap install ripgrep ccls --classic

