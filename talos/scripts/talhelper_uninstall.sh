#!/bin/bash

# Binary name
BINARY_NAME="talhelper"

# Check if the binary exists and remove it
if [ -f "/usr/local/bin/$BINARY_NAME" ]; then
    sudo rm "/usr/local/bin/$BINARY_NAME"
    echo "$BINARY_NAME uninstalled successfully."
else
    echo "$BINARY_NAME is not installed."
fi

