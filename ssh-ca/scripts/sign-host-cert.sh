#!/usr/bin/env bash
# Sign a host public key with the host CA.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_ca_root="$(cd "$script_dir/.." && pwd)"
ca_key="$ssh_ca_root/.keys/host_ca"

usage() {
  cat <<EOF
Usage: $(basename "$0") -k /path/to/host_key.pub [-n principals] [-V validity] [-o output] [-I identity]

Options:
  -k  Path to host public key to sign (required)
  -n  Comma-separated host principals (default: local hostname)
  -V  Validity period (ssh-keygen format, default: +52w)
  -o  Output certificate path (default: alongside key, *.cert.pub)
  -I  Certificate identity (default: host-<principal>-<timestamp>)
EOF
  exit 1
}

key_path=""
principals=""
validity="+52w"
output=""
identity=""

while getopts ":k:n:V:o:I:" opt; do
  case "$opt" in
    k) key_path="$OPTARG" ;;
    n) principals="$OPTARG" ;;
    V) validity="$OPTARG" ;;
    o) output="$OPTARG" ;;
    I) identity="$OPTARG" ;;
    *) usage ;;
  esac
done

[ -z "$key_path" ] && usage

if [ -z "$principals" ]; then
  principals="$(hostname -f 2>/dev/null || hostname)"
fi

if [ -z "$identity" ]; then
  identity="host-${principals%%,*}-$(date +%Y%m%d%H%M%S)"
fi

if [ ! -f "$key_path" ]; then
  echo "Host public key not found: $key_path" >&2
  exit 1
fi

if [ ! -f "$ca_key" ]; then
  echo "Host CA key missing: $ca_key" >&2
  exit 1
fi

key_dir="$(cd "$(dirname "$key_path")" && pwd)"
key_base="$(basename "$key_path")"
key_stem="${key_base%.pub}"
default_cert="${key_dir}/${key_stem}-cert.pub"
cert_path="${output:-$default_cert}"

echo "Signing host key:"
echo "  Key:        $key_path"
echo "  Principals: $principals"
echo "  Validity:   $validity"
echo "  Identity:   $identity"
echo "  Output:     $cert_path"

ssh-keygen -s "$ca_key" -I "$identity" -h -n "$principals" -V "$validity" -z "$(date +%s)" "$key_path"

if [ "$cert_path" != "$default_cert" ] && [ -f "$default_cert" ]; then
  mv "$default_cert" "$cert_path"
fi

echo "Host certificate written to $cert_path"
