#!/bin/bash

# Check if ipdb is installed (there should be an ipdb3 in the path)
which ipdb3 > /dev/null
if [ $? -ne 0 ]; then
    echo "ipdb is not installed"
    exit 1
fi

# Enable ipdb
export PYTHONBREAKPOINT="ipdb.set_trace"

echo 'export PYTHONBREAKPOINT="ipdb.set_trace"'
echo
echo "ipdb enabled"
