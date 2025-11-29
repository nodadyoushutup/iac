#!/usr/bin/env bash
# Remove generated CA material to simulate a fresh clone (with backups).

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_ca_root="$(cd "$script_dir/.." && pwd)"
keys_dir="$ssh_ca_root/.keys"

timestamp="$(date +%Y%m%d%H%M%S)"
backup_dir="$ssh_ca_root/reset-backups/$timestamp"
mkdir -p "$backup_dir"

move_if_exists() {
  local path="$1"
  if [ -f "$path" ]; then
    mv "$path" "$backup_dir/"
    echo "Moved $(basename "$path") to $backup_dir"
  fi
}

echo "Resetting CA materials (backups in $backup_dir)"
move_if_exists "$keys_dir/host_ca"
move_if_exists "$keys_dir/host_ca.pub"
move_if_exists "$keys_dir/user_ca"
move_if_exists "$keys_dir/user_ca.pub"

shopt -s nullglob
certs=("$ssh_ca_root"/*-cert.pub)
if [ "${#certs[@]}" -gt 0 ]; then
  mv "${certs[@]}" "$backup_dir/"
  echo "Moved ${#certs[@]} certificate(s) to $backup_dir"
fi
shopt -u nullglob

echo "[DONE] CA files removed from SSH CA directory. Re-run bootstrap-ca.sh to regenerate."
