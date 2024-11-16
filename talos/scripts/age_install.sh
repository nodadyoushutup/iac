#!/bin/bash

echo "Installing age"
sudo apt install age
# # Define the download URL and target binary path
# URL="https://dl.filippo.io/age/latest?for=linux/amd64"
# BINARY_PATH="/usr/local/bin/age"

# # Download the latest age binary
# curl -L -o age.tar.gz "$URL"

# # Extract the tar.gz file
# tar -xzf age.tar.gz

# # Move the binary to /usr/local/bin
# sudo mv age/age "$BINARY_PATH"

# # Make the binary executable
# sudo chmod +x "$BINARY_PATH"

# # Verify installation
# if command -v age &> /dev/null; then
#     echo "age installed successfully."
# else
#     echo "Installation failed."
#     exit 1
# fi

# # Clean up
# rm -rf age age.tar.gz

# echo "Installation and cleanup complete."
