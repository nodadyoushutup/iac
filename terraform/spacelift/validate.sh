#!/bin/sh

PRIVATE_KEY_PATH="$1"
chmod 600 "$PRIVATE_KEY_PATH"

# Run ssh-keygen -y to check if the private key is valid by generating the public key
# OUTPUT=$(ssh-keygen -y -f "$PRIVATE_KEY_PATH" 2>&1)
FIRST_LINE=$(head -n 1 "$PRIVATE_KEY_PATH")
LAST_LINE=$(tail -n 1 "$PRIVATE_KEY_PATH")


if echo "$FIRST_LINE" | grep -q "BEGIN OPENSSH PRIVATE KEY" && echo "$LAST_LINE" | grep -q "END OPENSSH PRIVATE KEY"; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
