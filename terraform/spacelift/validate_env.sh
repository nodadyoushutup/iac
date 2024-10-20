#!/bin/sh

PRIVATE_KEY_PATH="$1"
GITCONFIG_PATH="$2"

if [ -f "$PRIVATE_KEY_PATH" ]; then
  PRIVATE_KEY_FIRST_LINE=$(head -n 1 "$PRIVATE_KEY_PATH")
  PRIVATE_KEY_LAST_LINE=$(tail -n 1 "$PRIVATE_KEY_PATH")
  PRIVATE_KEY_VALID="false"
  chmod 600 $PRIVATE_KEY_PATH
  if echo "$PRIVATE_KEY_FIRST_LINE" | grep -q "BEGIN OPENSSH PRIVATE KEY" && echo "$PRIVATE_KEY_LAST_LINE" | grep -q "END OPENSSH PRIVATE KEY"; then
    PRIVATE_KEY_VALID="true"
  fi
fi

if [ -f "$GITCONFIG_PATH" ]; then
  if cat "$GITCONFIG_PATH" | grep -qE "^\s*name\s*=\s*\S+" && cat "$GITCONFIG_PATH" | grep -qE "^\s*email\s*=\s*\S+"; then
    GITCONFIG_VALID="true"
  fi
fi

if [ "$PRIVATE_KEY_VALID" = "true" ] && [ "$GITCONFIG_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
