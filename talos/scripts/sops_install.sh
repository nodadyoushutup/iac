#!/bin/bash

# Define the download URL and binary path
URL="https://github.com/getsops/sops/releases/download/v3.9.1/sops-v3.9.1.linux.amd64"
BINARY_PATH="/usr/local/bin/sops"

# Download the binary
curl -L -o sops-v3.9.1.linux.amd64 "$URL"

# Move the binary to /usr/local/bin
sudo mv sops-v3.9.1.linux.amd64 "$BINARY_PATH"

# Make the binary executable
sudo chmod +x "$BINARY_PATH"

# Verify installation
if command -v sops &> /dev/null; then
    echo "sops installed successfully."
else
    echo "Installation failed."
    exit 1
fi

echo "Installation complete."
