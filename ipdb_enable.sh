#!/bin/bash

# Check if ipdb is installed (there should be an ipdb3 in the path)
which ipdb3 > /dev/null
if [ $? -ne 0 ]; then
    echo "ipdb is not installed"
    exit 1
fi


# Find out if there is a venv activated
if [ -n "$VIRTUAL_ENV" ]; then
    # check if PYTHONBREAKPOINT is set in the activate script
    if ! grep -q 'PYTHONBREAKPOINT="ipdb.set_trace"' $VIRTUAL_ENV/bin/activate; then
        echo "VIRTUAL_ENV is set to $VIRTUAL_ENV, adding ipdb to it"
        echo 'export PYTHONBREAKPOINT="ipdb.set_trace"' >> $VIRTUAL_ENV/bin/activate
    else
        echo "PYTHONBREAKPOINT is already set in the activate script"
    fi
else
    echo "No venv activated"
    exit 1
fi

# Enable ipdb
export PYTHONBREAKPOINT="ipdb.set_trace"

echo 'export PYTHONBREAKPOINT="ipdb.set_trace"'
echo
echo "ipdb enabled"
