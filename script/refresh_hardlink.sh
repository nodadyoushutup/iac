#!/bin/bash

# Determine the directory where this script resides.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the terraform stack directory relative to the script directory.
STACK_DIR="$SCRIPT_DIR/../terraform/stack"

# Check if the stack directory exists.
if [ ! -d "$STACK_DIR" ]; then
    echo "Stack directory does not exist: $STACK_DIR"
    exit 1
fi

# Iterate over each first-level directory in the stack directory.
for d in "$STACK_DIR"/*; do
    if [ -d "$d" ]; then
        # Resolve the full path of the directory.
        FULL_PATH="$(readlink -f "$d")"
        echo "Refreshing hard links in directory: $FULL_PATH"
        
        # Call the create_hardlink script and pass the directory as an argument.
        "$SCRIPT_DIR/create_hardlink.sh" "$FULL_PATH"
        ret_code=$?
        if [ $ret_code -ne 0 ]; then
            echo "Error processing directory: $FULL_PATH"
        fi
    fi
done

echo "All hard links refreshed successfully."
exit 0
