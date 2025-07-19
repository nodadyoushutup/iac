#!/bin/bash

echo "Applying Netplan configuration..."
sudo netplan apply

if [ $? -eq 0 ]; then
    echo "Netplan applied successfully."
else
    echo "Failed to apply Netplan configuration." >&2
    exit 1
fi
