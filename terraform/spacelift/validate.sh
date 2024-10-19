#!/bin/sh
# Path to the YAML file (from the environment variable)
YAML_FILE="$1"



# Extract the value of path.private_key using grep and awk
PRIVATE_KEY_PATH=$(grep 'private_key' "$YAML_FILE" | awk -F '*:*' '{print $2}' | sed 's/"//g' | tr -d ' ')

# Run ssh-keygen and capture both stdout and stderr into a variable
OUTPUT=$(ssh-keygen -l -f "$PRIVATE_KEY_PATH" 2>&1)

ls -la /mnt/workspace
echo $OUTPUT

# Check if the output contains the phrase "not a public key file"
if echo "$OUTPUT" | grep -q "not a public key file"; then
  echo "+++++++++++++++++++++++++++++"
  echo $OUTPUT
elif echo "$OUTPUT" | grep -q "No such file or directory"; then
  echo "+++++++++++++++++++++++++++++"
  echo $OUTPUT
else
  echo "+++++++++++++++++++++++++++++"
  echo $OUTPUT
fi