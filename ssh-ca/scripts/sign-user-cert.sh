#!/usr/bin/env bash
# Sign a user public key with the user CA.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_ca_root="$(cd "$script_dir/.." && pwd)"
ca_key="$ssh_ca_root/.keys/user_ca"

usage() {
  cat <<EOF
Usage: $(basename "$0") -k /path/to/user_key.pub [-n principals] [-V validity] [-o output] [-I identity]

Options:
  -k  Path to user public key to sign (required)
  -n  Comma-separated principals/usernames (required)
  -V  Validity period (ssh-keygen format, default: +26w)
  -o  Output certificate path (default: alongside key, *.cert.pub)
  -I  Certificate identity (default: user-<principal>-<timestamp>)
EOF
  exit 1
}

key_path=""
principals=""
validity="+26w"
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
[ -z "$principals" ] && usage

if [ -z "$identity" ]; then
  identity="user-${principals%%,*}-$(date +%Y%m%d%H%M%S)"
fi

if [ ! -f "$key_path" ]; then
  echo "User public key not found: $key_path" >&2
  exit 1
fi

if [ ! -f "$ca_key" ]; then
  echo "User CA key missing: $ca_key" >&2
  exit 1
fi

key_dir="$(cd "$(dirname "$key_path")" && pwd)"
key_base="$(basename "$key_path")"
key_stem="${key_base%.pub}"
default_cert="${key_dir}/${key_stem}-cert.pub"
cert_path="${output:-$default_cert}"

echo "Signing user key:"
echo "  Key:        $key_path"
echo "  Principals: $principals"
echo "  Validity:   $validity"
echo "  Identity:   $identity"
echo "  Output:     $cert_path"

ssh-keygen -s "$ca_key" -I "$identity" -n "$principals" -V "$validity" -z "$(date +%s)" "$key_path"

if [ "$cert_path" != "$default_cert" ] && [ -f "$default_cert" ]; then
  mv "$default_cert" "$cert_path"
fi

echo "User certificate written to $cert_path"
