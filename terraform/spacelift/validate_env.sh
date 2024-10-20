#!/bin/sh

PRIVATE_KEY_PATH="$1"
chmod 600 "$PRIVATE_KEY_PATH"

FIRST_LINE=$(head -n 1 "$PRIVATE_KEY_PATH")
LAST_LINE=$(tail -n 1 "$PRIVATE_KEY_PATH")

PRIVATE_KEY_VALID="false"

if echo "$FIRST_LINE" | grep -q "BEGIN OPENSSH PRIVATE KEY" && echo "$LAST_LINE" | grep -q "END OPENSSH PRIVATE KEY"; then
  PRIVATE_KEY_VALID="true"
fi

# Check the value of PRIVATE_KEY_VALID and echo the result
if [ "$PRIVATE_KEY_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
