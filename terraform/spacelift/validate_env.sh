#!/bin/sh

PRIVATE_KEY_PATH="$1"
GITCONFIG_PATH="$2"
INVENTORY_PATH="$3"
ENV_PATH="$4"

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

if [ -f "$INVENTORY_PATH" ]; then
  if ! cat "$INVENTORY_PATH" | grep -q "000.000.000.000"; then
    INVENTORY_VALID="true"
  fi
fi

if [ -f "$ENV_PATH" ]; then
  if cat "$ENV_PATH" | grep -qE "^\s*POSTGRES_PASSWORD\s*=\s*\S+"; then
    ENV_PATH_VALID="true"
  fi
fi

if [ "$PRIVATE_KEY_VALID" = "true" ] && [ "$GITCONFIG_VALID" = "true" ] && [ "$INVENTORY_VALID" = "true" ] && [ "$ENV_PATH_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
