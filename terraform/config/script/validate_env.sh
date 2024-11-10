#!/bin/sh

TF_VAR_PRIVATE_KEY="$1"
PRIVATE_KEY_VALID="false"

if [ -f "$TF_VAR_PRIVATE_KEY" ]; then
  PRIVATE_KEY_FIRST_LINE=$(head -n 1 "$TF_VAR_PRIVATE_KEY")
  PRIVATE_KEY_LAST_LINE=$(tail -n 1 "$TF_VAR_PRIVATE_KEY")
  PRIVATE_KEY_VALID="false"
  chmod 600 $TF_VAR_PRIVATE_KEY
  if echo "$PRIVATE_KEY_FIRST_LINE" | grep -q "BEGIN OPENSSH PRIVATE KEY" && echo "$PRIVATE_KEY_LAST_LINE" | grep -q "END OPENSSH PRIVATE KEY"; then
    PRIVATE_KEY_VALID="true"
  fi
fi

if [ "$PRIVATE_KEY_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
