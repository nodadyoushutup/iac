#!/usr/bin/env bash
# Install the host CA public key into ssh_known_hosts for host certificate verification.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_ca_root="$(cd "$script_dir/.." && pwd)"
default_ca_pub="$ssh_ca_root/.keys/host_ca.pub"
ca_pub="$default_ca_pub"
known_hosts="/etc/ssh/ssh_known_hosts"
pattern="*"

usage() {
  cat <<EOF
Usage: sudo $(basename "$0") [-s /path/to/host_ca.pub] [-d /etc/ssh/ssh_known_hosts] [-p host-pattern]

Options:
  -s  Path to host CA public key (default: ${default_ca_pub})
  -d  ssh_known_hosts file to modify (default: /etc/ssh/ssh_known_hosts)
  -p  Host pattern to trust (default: *)
EOF
  exit 1
}

while getopts ":s:d:p:" opt; do
  case "$opt" in
    s) ca_pub="$OPTARG" ;;
    d) known_hosts="$OPTARG" ;;
    p) pattern="$OPTARG" ;;
    *) usage ;;
  esac
done

[ -f "$ca_pub" ] || { echo "Host CA public key not found: $ca_pub" >&2; exit 1; }

kh_dir="$(dirname "$known_hosts")"
[ -d "$kh_dir" ] || { echo "ssh directory missing: $kh_dir" >&2; exit 1; }

if [ -f "$known_hosts" ]; then
  [ -w "$known_hosts" ] || { echo "Cannot write $known_hosts (try sudo)" >&2; exit 1; }
else
  [ -w "$kh_dir" ] || { echo "Cannot create $known_hosts (try sudo)" >&2; exit 1; }
fi

line="@cert-authority $pattern $(cat "$ca_pub")"

if [ -f "$known_hosts" ] && grep -Fq "$line" "$known_hosts"; then
  echo "Entry already present in $known_hosts for pattern '$pattern'."
  exit 0
fi

if [ -f "$known_hosts" ]; then
  backup="${known_hosts}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$known_hosts" "$backup"
  echo "Backup created: $backup"
fi

printf "%s\n" "$line" >> "$known_hosts"
echo "Installed host CA entry into $known_hosts"
