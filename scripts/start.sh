#!/bin/bash

# Check if update.sh is available
if [ -f ./update.sh ]; then
    echo "update.sh found. Running update script..."
    ./update.sh
else
    ./scripts/update.sh
fi

sudo chmod a+rw /dev/ttyACM0

poetry run python server.py
