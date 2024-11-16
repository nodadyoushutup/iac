#!/bin/bash

# Download URL and binary name
URL="https://github.com/budimanjojo/talhelper/releases/download/v3.0.10/talhelper_linux_amd64.tar.gz"
BINARY_NAME="talhelper"

# Download the tar.gz file
curl -L -o "${BINARY_NAME}_linux_amd64.tar.gz" "$URL"

# Extract the tar.gz file
tar -xzf "${BINARY_NAME}_linux_amd64.tar.gz"

# Make the binary executable
chmod +x "$BINARY_NAME"

# Move the binary to /usr/local/bin for easy access
sudo mv "$BINARY_NAME" /usr/local/bin/

# Verify installation
if command -v "$BINARY_NAME" &> /dev/null; then
    echo "$BINARY_NAME installed successfully."
else
    echo "Installation failed."
    exit 1
fi

# Clean up the downloaded file
rm "${BINARY_NAME}_linux_amd64.tar.gz"
echo "Installation and cleanup complete."
