#!/usr/bin/env bash
# Ensure CA keys exist; generate if missing.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
keys_dir="$repo_root/.keys"

mkdir -p "$keys_dir"

host_ca="$keys_dir/host_ca"
user_ca="$keys_dir/user_ca"

generate_if_missing() {
  local path="$1"
  local comment="$2"

  if [ -f "$path" ]; then
    echo "[OK] Found $path"
    return
  fi

  echo "[..] Generating $path"
  ssh-keygen -t ed25519 -f "$path" -N "" -C "$comment"
  echo "[OK] Created $path and ${path}.pub"
}

echo "Bootstrap CA keys in $keys_dir"
generate_if_missing "$host_ca" "ssh-ca host $(hostname -f 2>/dev/null || hostname)"
generate_if_missing "$user_ca" "ssh-ca user $(hostname -f 2>/dev/null || hostname)"

echo "[DONE] CA keys are present."
