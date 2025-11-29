#!/usr/bin/env bash
# Install the user CA public key and configure sshd to trust it.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
ca_pub="$repo_root/.keys/user_ca.pub"
dest="/etc/ssh/user_ca.pub"
sshd_config="/etc/ssh/sshd_config"

usage() {
  cat <<EOF
Usage: sudo $(basename "$0") [-s /path/to/user_ca.pub] [-d /etc/ssh/user_ca.pub] [-c /etc/ssh/sshd_config]

Options:
  -s  Path to user CA public key (default: ./.keys/user_ca.pub)
  -d  Destination path to install the CA public key (default: /etc/ssh/user_ca.pub)
  -c  sshd_config path to update (default: /etc/ssh/sshd_config)
EOF
  exit 1
}

while getopts ":s:d:c:" opt; do
  case "$opt" in
    s) ca_pub="$OPTARG" ;;
    d) dest="$OPTARG" ;;
    c) sshd_config="$OPTARG" ;;
    *) usage ;;
  esac
done

[ -f "$ca_pub" ] || { echo "User CA public key not found: $ca_pub" >&2; exit 1; }
[ -f "$sshd_config" ] || { echo "sshd_config not found: $sshd_config" >&2; exit 1; }

dest_dir="$(dirname "$dest")"
[ -d "$dest_dir" ] || { echo "Destination directory missing: $dest_dir" >&2; exit 1; }

if [ -f "$dest" ]; then
  [ -w "$dest" ] || { echo "Cannot write $dest (try sudo)" >&2; exit 1; }
else
  [ -w "$dest_dir" ] || { echo "Cannot create $dest (try sudo)" >&2; exit 1; }
fi

[ -w "$sshd_config" ] || { echo "Cannot write $sshd_config (try sudo)" >&2; exit 1; }

if [ -f "$dest" ]; then
  dest_backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$dest" "$dest_backup"
  echo "Backup created: $dest_backup"
fi

install -m 0644 "$ca_pub" "$dest"

match_re="^TrustedUserCAKeys[[:space:]]+$dest[[:space:]]*$"
if grep -Eq "$match_re" "$sshd_config"; then
  echo "TrustedUserCAKeys already references $dest"
else
  sshd_backup="${sshd_config}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$sshd_config" "$sshd_backup"
  echo "Backup created: $sshd_backup"
  printf "\nTrustedUserCAKeys %s\n" "$dest" >> "$sshd_config"
  echo "Added TrustedUserCAKeys $dest to $sshd_config"
fi

echo "User CA installed at $dest"
echo "Reload sshd to apply: e.g., sudo systemctl reload sshd || sudo systemctl reload ssh"
