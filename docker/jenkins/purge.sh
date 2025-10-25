#!/usr/bin/env bash
set -euo pipefail

# Removes Docker assets that belong to Jenkins (services, configs, secrets,
# containers, volumes, networks, images) without touching unrelated resources.
# Environment variables:
#   SWARM_PURGE_AUTO_TRUST_SSH_HOSTS=1  Automatically add SSH host keys via ssh-keyscan.
#   SWARM_PURGE_KNOWN_HOSTS_FILE        Override the known_hosts file used when auto-trusting.
#   SWARM_PURGE_SSH_KEYSCAN_TIMEOUT     Timeout (seconds) for ssh-keyscan (default: 5).

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing command: $1" >&2
    exit 1
  }
}

need_cmd docker

if [[ "${SWARM_PURGE_AUTO_TRUST_SSH_HOSTS:-0}" == "1" ]]; then
  need_cmd ssh-keyscan
  need_cmd ssh-keygen
fi

remove_items() {
  local description=$1
  shift

  local -a list_cmd=()
  while (($#)); do
    if [[ $1 == "::" ]]; then
      shift
      break
    fi
    list_cmd+=("$1")
    shift
  done

  local -a remove_cmd=("$@")

  if ((${#list_cmd[@]} == 0)) || ((${#remove_cmd[@]} == 0)); then
    echo "Internal error: commands missing for ${description}" >&2
    return 1
  fi

  echo "==> Removing Jenkins ${description}..."
  local list_output line
  if ! list_output="$("${list_cmd[@]}" 2>&1)"; then
    echo "    warning: unable to list ${description}: ${list_output}" >&2
    return 1
  fi

  local -a items=()
  if [[ -n "${list_output}" ]]; then
    mapfile -t items <<<"${list_output}"$'\n'
  fi

  if ((${#items[@]} == 0)); then
    echo "    none found."
    return 0
  fi

  local -a unique_items=()
  while IFS= read -r line; do
    [[ -z "${line}" ]] && continue
    unique_items+=("${line}")
  done < <(printf '%s\n' "${items[@]}" | LC_ALL=C sort -u)

  if ((${#unique_items[@]} == 0)); then
    echo "    none found."
    return 0
  fi

  local removal_failed=0
  local item removal_output attempt success

  for item in "${unique_items[@]}"; do
    success=0
    removal_output=""

    for attempt in 1 2 3; do
      if removal_output="$("${remove_cmd[@]}" "${item}" 2>&1)"; then
        success=1
        break
      fi
      sleep 1
    done

    if ((success)); then
      if [[ -n "${removal_output}" ]]; then
        while IFS= read -r line; do
          [[ -z "${line}" ]] && continue
          printf '    %s\n' "${line}"
        done <<<"${removal_output}"
      else
        printf '    %s\n' "${item}"
      fi
    else
      removal_failed=1
      echo "    warning: failed to remove ${item}: ${removal_output}" >&2
    fi
  done

  if ((removal_failed)); then
    echo "    warning: failed to remove one or more ${description}" >&2
    return 1
  fi

  return 0
}

purge_node_assets() {
  local node_label=$1
  local had_error=0

  if ! remove_items "containers on ${node_label}" \
    docker ps -aq --filter name=jenkins \
    :: docker rm -f
  then
    had_error=1
  fi

  if ! remove_items "volumes on ${node_label}" \
    docker volume ls --filter name=jenkins --format '{{.Name}}' \
    :: docker volume rm -f
  then
    had_error=1
  fi

  if ! remove_items "networks on ${node_label}" \
    docker network ls --filter name=jenkins --format '{{.ID}}' \
    :: docker network rm
  then
    had_error=1
  fi

  if ! remove_items "images on ${node_label}" \
    docker image ls --filter "reference=*jenkins*" --quiet \
    :: docker image rm -f
  then
    had_error=1
  fi

  return "${had_error}"
}

host_allows_internal_suffix() {
  local host=$1

  [[ -n "${host}" ]] || return 1
  [[ "${host}" == *.* ]] && return 1
  [[ "${host}" == *:* ]] && return 1
  [[ "${host}" =~ ^[0-9]+(\.[0-9]+){3}$ ]] && return 1

  return 0
}

auto_trust_host_keys_enabled() {
  [[ "${SWARM_PURGE_AUTO_TRUST_SSH_HOSTS:-1}" == "1" ]]
}

ensure_known_host() {
  local host=$1

  auto_trust_host_keys_enabled || return 0

  local known_hosts_file=${SWARM_PURGE_KNOWN_HOSTS_FILE:-"${HOME}/.ssh/known_hosts"}
  local timeout=${SWARM_PURGE_SSH_KEYSCAN_TIMEOUT:-5}

  local scan_host=${host}
  local scan_port=""

  if [[ "${scan_host}" == \[*\] ]]; then
    scan_host="${scan_host#[}"
    scan_host="${scan_host%]}"
  fi

  if [[ "${scan_host}" == *:* ]]; then
    scan_port="${scan_host##*:}"
    scan_host="${scan_host%%:*}"
  fi

  local -a keyscan_args=(-T "${timeout}")
  [[ -n "${scan_port}" ]] && keyscan_args+=(-p "${scan_port}")
  keyscan_args+=("${scan_host}")

  local tmpfile
  tmpfile="$(mktemp)"

  if ssh-keyscan "${keyscan_args[@]}" >"${tmpfile}" 2>/dev/null && [[ -s "${tmpfile}" ]]; then
    mkdir -p "$(dirname "${known_hosts_file}")"

    if [[ -f "${known_hosts_file}" ]]; then
      ssh-keygen -R "${host}" -f "${known_hosts_file}" >/dev/null 2>&1 || true
      ssh-keygen -R "${scan_host}" -f "${known_hosts_file}" >/dev/null 2>&1 || true
      if [[ -n "${scan_port}" ]]; then
        ssh-keygen -R "[${scan_host}]:${scan_port}" -f "${known_hosts_file}" >/dev/null 2>&1 || true
      fi
    fi

    cat "${tmpfile}" >>"${known_hosts_file}"
    printf '    note: trusted SSH host key for %s\n' "${host}"
  else
    echo "    warning: failed to retrieve SSH host key for ${host}" >&2
  fi

  rm -f "${tmpfile}"
}

purge_remote_node() {
  local node_hostname=$1
  local node_addr=$2
  local ssh_user=$3

  local -a base_hosts=()
  local -a host_candidates=()
  local host fallback
  declare -A seen=()

  if [[ -n "${node_addr}" ]]; then
    base_hosts+=("${node_addr}")
  fi

  if [[ -n "${node_hostname}" && "${node_hostname}" != "${node_addr}" ]]; then
    base_hosts+=("${node_hostname}")
  fi

  if ((${#base_hosts[@]} == 0)); then
    echo "==> Skipping node ${node_hostname}; no usable address found." >&2
    return 1
  fi

  for host in "${base_hosts[@]}"; do
    if [[ -z "${seen[$host]:-}" ]]; then
      host_candidates+=("${host}")
      seen[$host]=1
    fi

    if host_allows_internal_suffix "${host}"; then
      fallback="${host}.internal"
      if [[ -z "${seen[$fallback]:-}" ]]; then
        host_candidates+=("${fallback}")
        seen[$fallback]=1
      fi
    fi
  done

  local attempt_host=""
  local success_host=""

  for attempt_host in "${host_candidates[@]}"; do
    ensure_known_host "${attempt_host}"
    echo "==> Purging Jenkins assets on node ${node_hostname} (${attempt_host})..."
    if DOCKER_HOST="ssh://${ssh_user}@${attempt_host}" purge_node_assets "${node_hostname}"; then
      success_host="${attempt_host}"
      break
    fi
    echo "    warning: purge attempt via ${attempt_host} failed." >&2
  done

  if [[ -z "${success_host}" ]]; then
    echo "    warning: failed to purge assets on ${node_hostname}" >&2
    return 1
  fi

  if [[ "${success_host}" != "${host_candidates[0]}" ]]; then
    echo "    note: purge succeeded via fallback host ${success_host}"
  fi

  return 0
}

echo "==> Purging Jenkins Docker assets..."

swarm_info="$(docker info --format '{{.Swarm.LocalNodeState}} {{.Swarm.ControlAvailable}} {{.Swarm.NodeID}}' 2>/dev/null || echo "inactive false")"
read -r swarm_local_state swarm_control_available local_node_id <<<"${swarm_info}"
manager_ops_available=false

if [[ "${swarm_local_state}" != "active" ]]; then
  echo "==> This node is not part of an active swarm; skipping manager-only resources."
elif [[ "${swarm_control_available}" == "true" ]]; then
  manager_ops_available=true
else
  echo "==> This node is not a swarm manager; skipping manager-only resources."
fi

if [[ "${manager_ops_available}" == "true" ]]; then
  if ! remove_items "stacks" \
    bash -lc "docker stack ls --format '{{.Name}}' | awk '/jenkins/'" \
    :: docker stack rm
  then
    echo "    warning: failed to remove one or more stacks" >&2
  fi

  if ! remove_items "services" \
    docker service ls --filter name=jenkins --format '{{.ID}}' \
    :: docker service rm
  then
    echo "    warning: failed to remove one or more services" >&2
  fi

  if ! remove_items "configs" \
    docker config ls --filter name=jenkins --format '{{.ID}}' \
    :: docker config rm
  then
    echo "    warning: failed to remove one or more configs" >&2
  fi

  if ! remove_items "secrets" \
    docker secret ls --filter name=jenkins --format '{{.ID}}' \
    :: docker secret rm
  then
    echo "    warning: failed to remove one or more secrets" >&2
  fi
fi

if ! purge_node_assets "local node"; then
  echo "    warning: failed to purge assets on local node" >&2
fi

if [[ "${manager_ops_available}" == "true" && "${SWARM_PURGE_SKIP_REMOTE:-0}" != "1" ]]; then
  ssh_user="${SWARM_PURGE_SSH_USER:-$(id -un)}"

  mapfile -t swarm_nodes < <(docker node ls --format '{{.ID}} {{.Hostname}} {{.Status}}')

  for node_entry in "${swarm_nodes[@]}"; do
    read -r node_id node_hostname node_status <<<"${node_entry}"

    [[ -z "${node_id}" || "${node_status,,}" != "ready" ]] && continue
    [[ -n "${local_node_id}" && "${node_id}" == "${local_node_id}" ]] && continue

    node_addr="$(docker node inspect "${node_id}" --format '{{.Status.Addr}}' 2>/dev/null | tr -d '[:space:]')"
    if [[ -z "${node_addr}" ]]; then
      echo "==> Skipping node ${node_hostname} (${node_id}); unable to determine management address." >&2
      continue
    fi

    purge_remote_node "${node_hostname}" "${node_addr}" "${ssh_user}"
  done
fi

echo "==> Jenkins Docker assets purge complete."
