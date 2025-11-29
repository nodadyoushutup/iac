#!/usr/bin/env bash
# Add HostCertificate to sshd_config for a server host cert (with backup).

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

cert_path="/etc/ssh/ssh_host_ed25519_key-cert.pub"
sshd_config="/etc/ssh/sshd_config"

usage() {
  cat <<EOF
Usage: sudo $(basename "$0") [-c /etc/ssh/ssh_host_ed25519_key-cert.pub] [-s /etc/ssh/sshd_config]

Options:
  -c  Host certificate path to reference in sshd_config (default: /etc/ssh/ssh_host_ed25519_key-cert.pub)
  -s  sshd_config path to edit (default: /etc/ssh/sshd_config)
EOF
  exit 1
}

while getopts ":c:s:" opt; do
  case "$opt" in
    c) cert_path="$OPTARG" ;;
    s) sshd_config="$OPTARG" ;;
    *) usage ;;
  esac
done

[ -f "$cert_path" ] || { echo "Host certificate not found: $cert_path" >&2; exit 1; }
[ -f "$sshd_config" ] || { echo "sshd_config not found: $sshd_config" >&2; exit 1; }
[ -w "$sshd_config" ] || { echo "Cannot write $sshd_config (try sudo)" >&2; exit 1; }

timestamp="$(date +%Y%m%d%H%M%S)"
backup="${sshd_config}.bak.${timestamp}"
cp "$sshd_config" "$backup"
echo "Backup created: $backup"

match_re="^[[:space:]]*HostCertificate[[:space:]]+$cert_path[[:space:]]*$"
if grep -Eq "$match_re" "$sshd_config"; then
  echo "HostCertificate already set to $cert_path in $sshd_config"
  exit 0
fi

tmp="$(mktemp)"
printf "\nHostCertificate %s\n" "$cert_path" >> "$tmp"
cat "$sshd_config" >> "$tmp"
mv "$tmp" "$sshd_config"
echo "Added HostCertificate $cert_path to $sshd_config"
echo "Reload sshd: sudo systemctl reload sshd || sudo systemctl reload ssh"
