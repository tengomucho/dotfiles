#!/bin/bash

python -c 'import importlib.util; exit(importlib.util.find_spec("ipdb") is None)'
if [[ $? == 0 ]]
then
    echo "ipdb already installed"
    exit 0
fi;

python_bin=`which python3`
venv_bindir=`dirname $python_bin`

grep 'uv = ' $venv_bindir/../pyvenv.cfg > /dev/null
if [[ $? == 0 ]]
then
    uv pip install ipdb
else
    pip install ipdb
fi;

echo 'export PYTHONBREAKPOINT="ipdb.set_trace"' >> $venv_bindir/activate

echo
echo 'If you want you can now do:'
echo 'export PYTHONBREAKPOINT="ipdb.set_trace"'
echo
echo "ipdb installed!"
