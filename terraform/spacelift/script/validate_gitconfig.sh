#!/bin/sh

GITCONFIG_PATH="$1"
GITCONFIG_VALID="false"

if [ -f "$GITCONFIG_PATH" ]; then
  if cat "$GITCONFIG_PATH" | grep -qE "^\s*name\s*=\s*\S+" && cat "$GITCONFIG_PATH" | grep -qE "^\s*email\s*=\s*\S+"; then
    GITCONFIG_VALID="true"
  fi
fi

if [ "$GITCONFIG_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
