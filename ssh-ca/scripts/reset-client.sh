#!/usr/bin/env bash
# Remove host CA trust from ssh_known_hosts to revert client behavior.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_ca_root="$(cd "$script_dir/.." && pwd)"
default_ca_pub="$ssh_ca_root/.keys/host_ca.pub"
ca_pub="$default_ca_pub"
known_hosts="/etc/ssh/ssh_known_hosts"

usage() {
  cat <<EOF
Usage: sudo $(basename "$0") [-d /etc/ssh/ssh_known_hosts] [-s /path/to/host_ca.pub]

Options:
  -d  ssh_known_hosts file to clean (default: /etc/ssh/ssh_known_hosts)
  -s  CA public key used for matching (default: ${default_ca_pub} if present)
EOF
  exit 1
}

while getopts ":d:s:" opt; do
  case "$opt" in
    d) known_hosts="$OPTARG" ;;
    s) ca_pub="$OPTARG" ;;
    *) usage ;;
  esac
done

if [ ! -f "$known_hosts" ]; then
  echo "No $known_hosts present; nothing to reset."
  exit 0
fi

kh_dir="$(dirname "$known_hosts")"
[ -w "$known_hosts" ] || [ -w "$kh_dir" ] || { echo "Cannot modify $known_hosts (try sudo)" >&2; exit 1; }

timestamp="$(date +%Y%m%d%H%M%S)"
reset_backup="${known_hosts}.reset.$timestamp"
cp "$known_hosts" "$reset_backup"
echo "Backup saved: $reset_backup"

# Prefer restoring from an install backup if available.
install_backup="$(find "$kh_dir" -maxdepth 1 -name "$(basename "$known_hosts").bak.*" -type f 2>/dev/null | sort -r | head -n1)"
if [ -n "$install_backup" ]; then
  cp "$install_backup" "$known_hosts"
  echo "Restored $known_hosts from install backup: $install_backup"
  exit 0
fi

tmp="$(mktemp)"
if [ -f "$ca_pub" ]; then
  ca_material="$(cat "$ca_pub")"
  grep -Fv "$ca_material" "$reset_backup" | grep -v '^@cert-authority' > "$tmp"
else
  echo "CA public key $ca_pub not found; stripping all @cert-authority entries."
  grep -v '^@cert-authority' "$reset_backup" > "$tmp"
fi

mv "$tmp" "$known_hosts"
echo "Removed CA trust entries from $known_hosts"
