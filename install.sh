#!/bin/sh

# directory where this script is located, thanks to
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s $DIR/gdbinit $HOME/.gdbinit
ln -s $DIR/mybashrc $HOME/.mybashrc

# for neovim
mkdir -p $HOME/.config/nvim
ln -s $DIR/vimrc $HOME/.config/nvim/init.vim

# for gvim/macvim
ln -s $DIR/vimrc $HOME/.vimrc

# for coc.nvim
mkdir -p $HOME/.vim
ln -s $DIR/coc-settings.json $HOME/.vim/coc-settings.json

ln -s $DIR/uncrustify.cfg ~/.uncrustify.cfg

# tmux
ln -s $DIR/tmux.conf ~/.tmux.conf

# global gitignore
ln -s $DIR/gitignore ~/.gitignore
git config --global core.excludesfile '~/.gitignore'

# for YouCompleteMe (Vim plugin)
curl https://raw.githubusercontent.com/Valloric/ycmd/master/cpp/ycm/.ycm_extra_conf.py > ~/.ycm_extra_conf.py

# for npm
echo 'prefix = ${NPM_PACKAGES}' >> ~/.npmrc

# custom path
mkdir -p ~/.bin
mkdir -p ~/.local/bin

# ripgrep shortcut
ln -s $DIR/bin/rg ~/.bin

# python3 by default
ln -s /usr/bin/python3 ~/.bin/python

# vscode
ln -sf $DIR/settings.json ~/.config/Code/User/settings.json


echo
echo "Consider installing node.js by typing:"
echo "curl -sL install-node.now.sh/lts | PREFIX=~/.local bash"


echo
echo "Install done"
echo "if needed add . .mybashrc at the end of your .bashrc."


