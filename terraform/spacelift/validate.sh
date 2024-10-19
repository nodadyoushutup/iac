#!/bin/sh

PRIVATE_KEY_PATH="$1"
chmod 600 "$PRIVATE_KEY_PATH"

# Run ssh-keygen -y to check if the private key is valid by generating the public key
OUTPUT=$(ssh-keygen -y -f "$PRIVATE_KEY_PATH" 2>&1)

echo $OUTPUT

# Check if ssh-keygen failed
if echo "$OUTPUT" | grep -q "load failed"; then
  echo "{\"valid\": \"false\"}"
else
  echo "{\"valid\": \"true\"}"
fi
