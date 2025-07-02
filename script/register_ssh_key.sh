#!/bin/bash
set -euo pipefail

GITHUB_PAT="${GITHUB_PAT:-}"  # Must be set as an environment variable
SSH_KEY_FILE="${1:-$HOME/.ssh/id_rsa.pub}"

if [[ -z "$GITHUB_PAT" ]]; then
    echo "[ERROR] GITHUB_PAT environment variable is not set"
    exit 1
fi

if [[ ! -f "$SSH_KEY_FILE" ]]; then
    echo "[ERROR] SSH key file not found: $SSH_KEY_FILE"
    exit 1
fi

PUB_KEY_CONTENT=$(<"$SSH_KEY_FILE")
PUB_KEY_CONTENT_STRIPPED=$(echo "$PUB_KEY_CONTENT" | awk '{print $1,$2}')  # Strip comment

# Fetch existing keys
EXISTING_KEYS=$(curl -s -H "Authorization: token $GITHUB_PAT" https://api.github.com/user/keys)

# Check if key already exists
if echo "$EXISTING_KEYS" | jq -e --arg key "$PUB_KEY_CONTENT_STRIPPED" '.[] | select(.key == $key)' > /dev/null; then
    echo "[INFO] SSH key already exists on GitHub. Skipping..."
else
    echo "[INFO] SSH key not found. Adding to GitHub..."
    curl -s -X POST -H "Authorization: token $GITHUB_PAT" \
        -d "{\"title\":\"$(hostname) - $(date +%Y-%m-%d)\",\"key\":\"$PUB_KEY_CONTENT\"}" \
        https://api.github.com/user/keys \
        | jq .
    echo "[INFO] SSH key added successfully."
fi
