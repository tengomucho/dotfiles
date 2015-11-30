#!/bin/sh

# directory where this script is located, thanks to
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s $DIR/gdbinit $HOME/.gdbinit
ln -s $DIR/mybashrc $HOME/.mybashrc
ln -s $DIR/vimrc $HOME/.vimrc

echo
echo "Install done"
echo "if needed add . .mybashrc at the end of your .bashrc."

