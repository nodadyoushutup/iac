#!/bin/sh

INVENTORY_PATH="$1"
INVENTORY_VALID="false"

if [ -f "$INVENTORY_PATH" ]; then
  if ! cat "$INVENTORY_PATH" | grep -q "000.000.000.000"; then
    INVENTORY_VALID="true"
  fi
fi

if [ "$INVENTORY_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
