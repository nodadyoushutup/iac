#!/usr/bin/env bash
set -euo pipefail

# Usage: import-ssh-keys.sh <username> <github-account>
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <username> <github-account>"
  exit 1
fi

username="$1"
github="$2"

# Ensure ssh-import-id is available
if ! command -v ssh-import-id &>/dev/null; then
  echo "Error: ssh-import-id not found. Please install it first."
  exit 1
fi

# Ensure the user exists on the system
if ! id "$username" &>/dev/null; then
  echo "Error: User '$username' does not exist."
  exit 1
fi

# Temporarily switch to the target user and import their GitHub SSH keys
su - "$username" -c "ssh-import-id gh:${github}"

echo "Imported SSH keys for GitHub user '${github}' into ${username}'s account."
