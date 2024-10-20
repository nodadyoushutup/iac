#!/bin/sh

PRIVATE_KEY_PATH="$1"
GITCONFIG_PATH="$2"

# Check for the private key validity
PRIVATE_KEY_FIRST_LINE=$(head -n 1 "$PRIVATE_KEY_PATH")
PRIVATE_KEY_LAST_LINE=$(tail -n 1 "$PRIVATE_KEY_PATH")
PRIVATE_KEY_VALID="false"
chmod 600 "$PRIVATE_KEY_PATH"

if [ -f "$PRIVATE_KEY_PATH" ]; then
  if echo "$PRIVATE_KEY_FIRST_LINE" | grep -q "BEGIN OPENSSH PRIVATE KEY" && echo "$PRIVATE_KEY_LAST_LINE" | grep -q "END OPENSSH PRIVATE KEY"; then
    PRIVATE_KEY_VALID="true"
  fi
fi

# Check for the gitconfig file validity (simple check for existence and basic format)
if [ -f "$GITCONFIG_PATH" ]; then
  if grep -qE "^\s*name\s*=\s*\S+"; then
    GITCONFIG_VALID="true"
  fi
fi

# Check the value of PRIVATE_KEY_VALID and echo the result for the private key
if [ "$PRIVATE_KEY_VALID" = "true" && "$GITCONFIG_VALID" = "true"]; then
  echo "{\"private_key_valid\": \"true\"}"
else
  echo "{\"private_key_valid\": \"false\"}"
fi