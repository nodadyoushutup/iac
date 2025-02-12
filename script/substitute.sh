#!/bin/bash

# Set environment variables
export FOO="Hello"
export BAR="World"

# Create a template file
cat <<EOF > template.txt
This is a test file.
FOO is $FOO
BAR is $BAR
EOF

# Substitute environment variables and create a new file
envsubst < template.txt > output.txt

# Display output file
cat output.txt
