#!/bin/sh
# Path to the YAML file (from the environment variable)
YAML_FILE="$1"

# Extract the value of path.private_key using grep and awk
PRIVATE_KEY_PATH=$(grep 'private_key' "$YAML_FILE" | awk -F '*:*' '{print $2}' | sed 's/"//g' | tr -d ' ')

# Run ssh-keygen and capture both stdout and stderr into a variable
OUTPUT=$(ssh-keygen -l -f "$PRIVATE_KEY_PATH" 2>&1)

echo $YAML_FILE
echo $PRIVATE_KEY_PATH
echo $OUTPUT

if echo "$OUTPUT" | grep -q "(RSA)"; then
  echo "{\"valid\": \"true\"}" 
else
  echo "{\"valid\": \"false\"}" 
fi
