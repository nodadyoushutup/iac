#!/usr/bin/env bash
# SSH CA connectivity spot-check: full matrix between machines plus dev<->machines with readable output.

set -euo pipefail

SSH_OPTS=${SSH_OPTS:-"-o StrictHostKeyChecking=accept-new"}

if [ "$#" -gt 0 ]; then
  machines=("$@")
else
  machines=(swarm-cp-0.internal swarm-wk-0.internal swarm-wk-1.internal swarm-wk-2.internal swarm-wk-3.internal)
fi

if [ "${#machines[@]}" -eq 0 ]; then
  echo "No nodes provided" >&2
  exit 1
fi

# Colors (fallback to plain if tput is unavailable or not a TTY).
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
  BOLD=$(tput bold); RESET=$(tput sgr0)
  GREEN=$(tput setaf 2); RED=$(tput setaf 1); CYAN=$(tput setaf 6)
else
  BOLD=; RESET=; GREEN=; RED=; CYAN=
fi

ok="${GREEN}[OK]${RESET}"
fail="${RED}[FAIL]${RESET}"

print_section() {
  echo
  printf "%s==> %s%s\n" "$BOLD" "$1" "$RESET"
  printf "%s\n" "------------------------------------------------------------"
}

ok_count=0
fail_count=0

run_check() {
  local label="$1"; shift
  if eval "$@" >/dev/null 2>&1; then
    printf "%-45s %s\n" "$label" "$ok"
    ok_count=$((ok_count + 1))
  else
    printf "%-45s %s\n" "$label" "$fail"
    fail_count=$((fail_count + 1))
  fi
}

dev_host=$(hostname -f 2>/dev/null || hostname)
# Ensure the dev host uses the internal FQDN for consistency.
case "$dev_host" in
  *.internal) ;;
  *) dev_host="${dev_host}.internal" ;;
esac

echo "${BOLD}SSH CA connectivity check${RESET}"
echo "Machines: ${machines[*]}"
echo "Dev host: $dev_host"
echo "SSH_OPTS: $SSH_OPTS"

print_section "Matrix (machine -> machine)"
for src in "${machines[@]}"; do
  for dst in "${machines[@]}"; do
    run_check "$src -> $dst" "ssh $SSH_OPTS \"$src\" \"ssh -o StrictHostKeyChecking=accept-new $dst hostname\""
  done
done

print_section "Dev -> machines"
for dst in "${machines[@]}"; do
  run_check "$dev_host -> $dst" "ssh $SSH_OPTS \"$dst\" hostname"
done

print_section "Machines -> dev"
for src in "${machines[@]}"; do
  run_check "$src -> $dev_host" "ssh $SSH_OPTS \"$src\" \"ssh -o StrictHostKeyChecking=accept-new $dev_host hostname\""
done

echo
printf "%sSummary:%s %sok=%d%s, %sfail=%d%s\n" "$BOLD" "$RESET" "$GREEN" "$ok_count" "$RESET" "$RED" "$fail_count" "$RESET"

if [ "$fail_count" -ne 0 ]; then
  exit 1
fi
