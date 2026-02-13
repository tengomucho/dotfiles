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

# Add aliases for git
git config --global alias.l 'log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
git config --global alias.co 'checkout'
git config --global alias.br 'branch'
git config --global alias.ci 'commit'
git config --global alias.st 'status'
git config --global alias.df 'diff'

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
echo "Install done"
echo "if needed add . .mybashrc at the end of your .bashrc or .zshrc."


