#!/bin/bash

python -c 'import importlib.util; exit(importlib.util.find_spec("ipdb") is None)'
if [[ $? == 0 ]]
then
    echo "ipdb already installed"
    exit 0
fi;

if [ -n "$VIRTUAL_ENV" ]; then
    echo 'export PYTHONBREAKPOINT="ipdb.set_trace"' >> $VIRTUAL_ENV/bin/activate
else
    echo "No venv activated"
    exit 1
fi

grep 'uv = ' $VIRTUAL_ENV/pyvenv.cfg > /dev/null
if [[ $? == 0 ]]
then
    uv pip install ipdb
else
    pip install ipdb
fi;


echo
echo 'If you want you can now do:'
echo 'export PYTHONBREAKPOINT="ipdb.set_trace"'
echo
echo "ipdb installed!"
