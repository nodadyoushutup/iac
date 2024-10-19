#!/bin/sh
# Path to the YAML file (from the environment variable)
YAML_FILE="$1"

# Extract the value of path.private_key using grep and awk
PRIVATE_KEY_PATH=$(grep 'private_key' "$YAML_FILE" | awk -F ':' '{print $2}' | sed 's/"//g' | tr -d ' ')

# Run ssh-keygen and capture both stdout and stderr into a variable
OUTPUT=$(ssh-keygen -l -f "$PRIVATE_KEY_PATH" 2>&1)

# Check if the output contains the phrase "not a public key file"
if echo "$OUTPUT" | grep -q "(RSA)"; then
  echo $OUTPUT
  echo "{\"valid\": \"true\"}" 
else
  echo $OUTPUT
  echo "{\"valid\": \"false\"}" 
fi
