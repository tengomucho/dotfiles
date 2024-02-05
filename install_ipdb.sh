#!/bin/bash

python -c 'import importlib.util; exit(importlib.util.find_spec("ipdb") is None)'
if [[ $? == 0 ]]
then
    echo "ipdb already installed"
    exit 0
fi;

python_bin=`which python3`
venv_bindir=`dirname $python_bin`

pip install ipdb
echo 'export PYTHONBREAKPOINT="ipdb.set_trace"' >> $venv_bindir/activate
echo "ipdb installed!"
