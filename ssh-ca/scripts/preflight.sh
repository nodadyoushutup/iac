#!/usr/bin/env bash
# Preflight check for the SSH CA host. Verifies tools and key files exist.

set -u

OK="[OK]"
FAIL="[X]"
issues=0

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ssh_ca_root="$(cd "$script_dir/.." && pwd)"
keys_dir="$ssh_ca_root/.keys"
cd "$ssh_ca_root"

status_line() {
  # status_line <0|1> <message> [detail]
  local ok="$1"
  local msg="$2"
  local detail="${3:-}"

  if [ "$ok" -eq 0 ]; then
    printf "%s %s" "$OK" "$msg"
  else
    printf "%s %s" "$FAIL" "$msg"
    issues=$((issues + 1))
  fi

  if [ -n "$detail" ]; then
    printf " - %s" "$detail"
  fi
  printf "\n"
}

check_command() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    status_line 0 "Command '$cmd' available" "$(command -v "$cmd")"
  else
    status_line 1 "Command '$cmd' available" "not found in PATH"
  fi
}

get_perm() {
  local path="$1"
  local perm

  if perm=$(stat -c "%a" "$path" 2>/dev/null); then
    printf "%s" "$perm"
    return 0
  fi

  if perm=$(stat -f "%Lp" "$path" 2>/dev/null); then
    printf "%s" "$perm"
    return 0
  fi

  return 1
}

check_file() {
  local path="$1"
  local label="$2"

  if [ -f "$path" ]; then
    status_line 0 "$label" "$path"
  else
    status_line 1 "$label" "expected at $path"
  fi
}

check_private_permissions() {
  local path="$1"

  [ -f "$path" ] || return 0

  local perm
  if ! perm=$(get_perm "$path"); then
    status_line 1 "Permissions locked down for $path" "stat unavailable"
    return
  fi

  case "$perm" in
    400|600)
      status_line 0 "Permissions locked down for $path" "$perm"
      ;;
    *)
      status_line 1 "Permissions locked down for $path" "$perm (want 600 or 400)"
      ;;
  esac
}

echo "SSH CA host preflight"
echo "SSH CA root: $ssh_ca_root"
echo "Keys dir:  $keys_dir"
echo

echo "Checking required commands..."
check_command ssh-keygen
check_command ssh
echo

echo "Checking CA key files..."
private_keys=("$keys_dir/host_ca" "$keys_dir/user_ca")
public_keys=("$keys_dir/host_ca.pub" "$keys_dir/user_ca.pub")

for key in "${private_keys[@]}"; do
  check_file "$key" "$key present"
  check_private_permissions "$key"
done

for key in "${public_keys[@]}"; do
  check_file "$key" "$key present"
done
echo

if [ "$issues" -eq 0 ]; then
  echo "[OK] Preflight PASSED. CA host looks ready."
  exit 0
else
  echo "[X] Preflight found $issues issue(s). See items above."
  exit 1
fi
