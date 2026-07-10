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

ln -sf $DIR/legacy/mybashrc $HOME/.mybashrc

# for neovim (points at the chezmoi-managed ~/.vimrc, not the repo directly)
mkdir -p $HOME/.config/nvim
ln -sf $HOME/.vimrc $HOME/.config/nvim/init.vim

# global gitignore
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

# ipdb installer and enabler
ln -sf  $DIR/legacy/install_ipdb.sh ~/.bin
ln -sf  $DIR/legacy/ipdb_enable.sh ~/.bin

# create useful dirs
mkdir -p ~/Dev

echo
echo "Install done"
echo "if needed add . .mybashrc at the end of your .bashrc or .zshrc."


