#!/bin/sh
# Path to the YAML file (from the environment variable)
YAML_FILE="${TF_VAR_CONFIG}"

# Extract the value of path.private_key using yq
PRIVATE_KEY_PATH=$(yq e '.path.private_key' "$YAML_FILE")

# Check if the private key is valid
if ssh-keygen -l -f "$PRIVATE_KEY_PATH" >/dev/null 2>&1; then
  echo "{\"valid\": \"true\"}"  # Return true as a string
else
  echo "{\"valid\": \"false\"}" # Return false as a string
fi
