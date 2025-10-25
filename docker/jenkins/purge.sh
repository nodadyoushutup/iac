#!/usr/bin/env bash
set -euo pipefail

# Removes Docker assets that belong to Jenkins (services, configs, secrets,
# containers, volumes, networks, images) without touching unrelated resources.

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing command: $1" >&2
    exit 1
  }
}

need_cmd docker

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
  mapfile -t items < <("${list_cmd[@]}" 2>/dev/null)

  if ((${#items[@]} == 0)); then
    echo "    none found."
    return 0
  fi

  if ! printf '%s\n' "${items[@]}" | LC_ALL=C sort -u | xargs -r "${remove_cmd[@]}"; then
    echo "    warning: failed to remove one or more ${description}" >&2
  fi
}

purge_node_assets() {
  local node_label=$1

  remove_items "containers on ${node_label}" \
    docker ps -aq --filter name=jenkins \
    :: docker rm -f

  remove_items "volumes on ${node_label}" \
    docker volume ls --filter name=jenkins --format '{{.Name}}' \
    :: docker volume rm -f

  remove_items "networks on ${node_label}" \
    docker network ls --filter name=jenkins --format '{{.ID}}' \
    :: docker network rm

  remove_items "images on ${node_label}" \
    docker image ls --filter "reference=*jenkins*" --quiet \
    :: docker image rm -f
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
  remove_items "stacks" \
    docker stack ls --filter name=jenkins --format '{{.Name}}' \
    :: docker stack rm

  remove_items "services" \
    docker service ls --filter name=jenkins --format '{{.ID}}' \
    :: docker service rm

  remove_items "configs" \
    docker config ls --filter name=jenkins --format '{{.ID}}' \
    :: docker config rm

  remove_items "secrets" \
    docker secret ls --filter name=jenkins --format '{{.ID}}' \
    :: docker secret rm
fi

purge_node_assets "local node"

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

    docker_host="ssh://${ssh_user}@${node_addr}"
    echo "==> Purging Jenkins assets on node ${node_hostname} (${node_addr})..."
    if ! DOCKER_HOST="${docker_host}" purge_node_assets "${node_hostname}"; then
      echo "    warning: failed to purge assets on ${node_hostname}" >&2
    fi
  done
fi

echo "==> Jenkins Docker assets purge complete."
