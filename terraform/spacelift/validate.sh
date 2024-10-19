#!/bin/sh

PRIVATE_KEY_PATH="$1"
chmod 600 $PRIVATE_KEY_PATH
OUTPUT=$(ssh-keygen -l -f "$PRIVATE_KEY_PATH" 2>&1)

ls -la /mnt/workspace

cat $PRIVATE_KEY_PATH

echo $YAML_FILE
echo $PRIVATE_KEY_PATH
echo $OUTPUT

if echo "$OUTPUT" | grep -q "(RSA)"; then
  echo "{\"valid\": \"true\"}" 
else
  echo "{\"valid\": \"false\"}" 
fi
