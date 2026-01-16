#!/bin/sh

set -e

# directory where this script is located
DIR=`dirname "$BASH_SOURCE"`
DIR=`realpath $DIR`

ln -sf $DIR/gdbinit $HOME/.gdbinit
ln -sf $DIR/mybashrc $HOME/.mybashrc

# for neovim
mkdir -p $HOME/.config/nvim
ln -sf $DIR/vimrc $HOME/.config/nvim/init.vim

# for gvim/macvim
ln -sf $DIR/vimrc $HOME/.vimrc

# tmux
ln -sf $DIR/tmux.conf ~/.tmux.conf

# global gitignore
ln -sf $DIR/gitignore ~/.gitignore
git config --global core.excludesfile '~/.gitignore'

# for YouCompleteMe (Vim plugin)
curl https://raw.githubusercontent.com/Valloric/ycmd/master/cpp/ycm/.ycm_extra_conf.py > ~/.ycm_extra_conf.py

# for npm
echo 'prefix = ${NPM_PACKAGES}' >> ~/.npmrc

# custom path
mkdir -p ~/.bin
mkdir -p ~/.local/bin

# python3 by default
ln -sf /usr/bin/python3 ~/.bin/python

# vscode
mkdir -p ~/.config/Code/User/
ln -sff $DIR/settings.json ~/.config/Code/User/settings.json

# lldbattach helper
ln -sf  $DIR/lldbattach ~/.bin

# ipdb installer and enabler
ln -sf  $DIR/install_ipdb.sh ~/.bin
ln -sf  $DIR/ipdb_enable.sh ~/.bin

# create useful dirs
mkdir -p ~/Dev

echo
echo "Consider installing node.js by typing:"
echo "curl -sL install-node.now.sh/lts | PREFIX=~/.local bash"


echo
echo "Install done"
echo "if needed add . .mybashrc at the end of your .bashrc or .zshrc."


