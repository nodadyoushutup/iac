#!/bin/sh

ENV_PATH="$1"
ENV_PATH_VALID="false"

if [ -f "$ENV_PATH" ]; then
  if cat "$ENV_PATH" | grep -qE "^\s*POSTGRES_PASSWORD\s*=\s*\S+"; then
    ENV_PATH_VALID="true"
  fi
fi

if [ "$ENV_PATH_VALID" = "true" ]; then
  echo "{\"valid\": \"true\"}"
else
  echo "{\"valid\": \"false\"}"
fi
