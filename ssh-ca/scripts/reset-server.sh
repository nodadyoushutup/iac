#!/usr/bin/env bash
# Remove user CA trust from sshd to revert to default auth behavior.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

ca_dest="/etc/ssh/user_ca.pub"
sshd_config="/etc/ssh/sshd_config"

usage() {
  cat <<EOF
Usage: sudo $(basename "$0") [-d /etc/ssh/user_ca.pub] [-c /etc/ssh/sshd_config]

Options:
  -d  Path to CA public key that was installed (default: /etc/ssh/user_ca.pub)
  -c  sshd_config path to clean (default: /etc/ssh/sshd_config)
EOF
  exit 1
}

while getopts ":d:c:" opt; do
  case "$opt" in
    d) ca_dest="$OPTARG" ;;
    c) sshd_config="$OPTARG" ;;
    *) usage ;;
  esac
done

[ -f "$sshd_config" ] || { echo "sshd_config not found: $sshd_config" >&2; exit 1; }
[ -w "$sshd_config" ] || { echo "Cannot modify $sshd_config (try sudo)" >&2; exit 1; }

timestamp="$(date +%Y%m%d%H%M%S)"
reset_backup="${sshd_config}.reset.$timestamp"
cp "$sshd_config" "$reset_backup"
echo "Backup saved: $reset_backup"

config_dir="$(dirname "$sshd_config")"
install_backup="$(find "$config_dir" -maxdepth 1 -name "$(basename "$sshd_config").bak.*" -type f 2>/dev/null | sort -r | head -n1)"
if [ -n "$install_backup" ]; then
  cp "$install_backup" "$sshd_config"
  echo "Restored $sshd_config from install backup: $install_backup"
else
  tmp="$(mktemp)"
  grep -Ev '^[[:space:]]*TrustedUserCAKeys[[:space:]]+' "$reset_backup" > "$tmp"
  mv "$tmp" "$sshd_config"
  echo "Removed TrustedUserCAKeys from $sshd_config"
fi

if [ -f "$ca_dest" ]; then
  ca_backup="${ca_dest}.reset.$timestamp"
  mv "$ca_dest" "$ca_backup"
  echo "Moved $ca_dest to $ca_backup"
fi

echo "Reset complete. Reload sshd if it is running."
