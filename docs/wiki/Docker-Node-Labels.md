# Docker Swarm: nodes, labels, and constraints (quick guide)

> Run these on a Swarm **manager** node.

## Label strategy overview
- Keep labels lightweight (`key=value` strings) and scoped to scheduling needs. A common pattern is `role=<function>` so constraints read naturally.
- Apply labels to every node as part of provisioning so schedulers avoid "unknown" nodes. Record label intent next to any automation (Terraform, Ansible) that writes it.
- Combine labels with node availability/taints when you must isolate critical workloads (for example, pin databases to SSD-backed managers plus `role=database`).
- Double-check that labels land in `.Spec.Labels`; `docker node update` writes there while container labels live elsewhere.

## Known labels in this swarm

### `role=cicd`
- **Intent**: Reserve nodes that host Jenkins controller/agents and other CI tooling so pipelines do not compete with stateful services.
- **Placement**: Add the label to nodes with fast storage and close network proximity to the registry/MinIO backends.
- **Usage**:
  ```bash
  docker node update --label-add role=cicd swarm-wk-0
  docker node update --label-rm role swarm-wk-0
  docker service create --name my-ci-runner --constraint 'node.labels.role==controller' alpine:3.20 sleep 1d
  ```

### `role=monitoring`
- **Intent**: Keep Grafana, Prometheus, Alertmanager, and exporters on nodes sized for metrics retention.
- **Placement**: Apply to nodes that already run Swarm stacks like Grafana and Prometheus or have extra RAM/CPU for scraping.
- **Usage**:
  ```bash
  docker node update --label-add role=monitoring swarm-wk-2
  docker node update --label-rm role swarm-wk-2
  docker service create --name prom --constraint 'node.labels.role==controller' prom/prometheus
  ```

### `role=database`
- **Intent**: Protect nodes with durable disks (NVMe/ZFS) for PostgreSQL, MinIO, or any stateful data service.
- **Placement**: Restrict database services to these nodes and avoid co-locating noisy neighbors.
- **Usage**:
  ```bash
  docker node update --label-add role=database swarm-wk-3
  docker node update --label-rm role swarm-wk-3
  docker service create --name pg --constraint 'node.labels.role==controller' postgres:16
  ```

### `role=edge`
- **Intent**: Host perimeter workloads that terminate TLS and face the public internet (Nginx Proxy Manager, future WAF/ACME helpers) so the rest of the cluster stays interior-only.
- **Placement**: Label DMZ-capable workers that sit closest to the router/firewall; keep noisy/stateful apps off these nodes so reverse proxies stay responsive.
- **Usage**:
  ```bash
  docker node update --label-add role=edge swarm-wk-2
  docker node update --label-rm role swarm-wk-1
  docker service create --name npm --constraint 'node.labels.role==controller' jc21/nginx-proxy-manager:2.11.4
  ```

## Current homelab node map

| Node        | Swarm role | Availability | Labels         | Notes                                  |
|-------------|------------|--------------|----------------|----------------------------------------|
| `swarm-cp-0`| manager    | active       | _none yet_     | Controller/leader, safe place for infra control planes but avoid heavy workloads. |
| `swarm-wk-0`| worker     | active       | `role=cicd`    | Hosts Jenkins controller/agents and related CI services. |
| `swarm-wk-1`| worker     | active       | `role=edge`    | Dedicated perimeter node for Nginx Proxy Manager / TLS termination. |
| `swarm-wk-2`| worker     | active       | `role=monitoring` | Runs Prometheus/Grafana/Alertmanager stacks. |
| `swarm-wk-3`| worker     | active       | `role=database`| Primary database node (Postgres/MinIO) with durable storage. |

> Keep this table updated as nodes change roles. Label the manager if you ever need to pin control-plane services (for example, `role=control-plane`).

## Fast label commands for this cluster
```bash
# ensure existing labels stay present
docker node update --label-add role=cicd swarm-wk-0
docker node update --label-add role=monitoring swarm-wk-2
docker node update --label-add role=database swarm-wk-3
docker node update --label-add role=edge swarm-wk-1

# promote additional database nodes (pick workers with SSD/NVMe)
docker node update --label-add role=database NODE_WITH_FAST_DISKS   # replace placeholder with the target worker

# quick removals when shifting roles
docker node update --label-rm role swarm-wk-0
docker node update --label-rm role swarm-wk-2
docker node update --label-rm role swarm-wk-1
docker node update --label-rm role swarm-wk-3

# optional: label the controller if you need manager-only workloads
docker node update --label-add role=control-plane swarm-cp-0
docker node update --label-rm role swarm-cp-0             # drop control-plane label when opening scheduling
```

## 1) See your Docker nodes
```bash
# list all nodes in the Swarm
docker node ls

# (optional) quick view with hostname + availability + labels
docker node ls --format 'table {{.ID}}	{{.Hostname}}	{{.Availability}}	{{.ManagerStatus}}'
```

## 2) See what labels a node has
```bash
# show labels for ONE node (replace NODE with ID or hostname from `docker node ls`)
docker node inspect NODE --format '{{ json .Spec.Labels }}'

# pretty-print labels (requires jq)
docker node inspect NODE | jq '.[0].Spec.Labels'

# full human-readable inspect (labels included near the top)
docker node inspect --pretty NODE
```

## 3) Add (or change) a label (e.g., role=cicd)
```bash
# add/update label "role=cicd" on a node
docker node update --label-add role=cicd NODE

# verify
docker node inspect NODE --format '{{ json .Spec.Labels }}'
```

> Notes:
> - Use `--label-rm key` to remove a label.
> - Labels live in `.Spec.Labels`, so updates are done with `docker node update`.

## 4) Use the label in placement constraints

### A) With `docker service create`
```bash
docker service create   --name my-ci-runner   --constraint 'node.labels.role==controller'   alpine:3.20 sleep 1d
```

### B) In a Compose/Stack file (`docker stack deploy`)
```yaml
# docker-compose.yml
version: "3.8"
services:
  my-ci-runner:
    image: alpine:3.20
    command: ["sleep","1d"]
    deploy:
      placement:
        constraints:
          - node.labels.role==controller
```
```bash
docker stack deploy -c docker-compose.yml mystack
```

### C) In code (array style), e.g. Pulumi/Terraform/SDKs
```json
{
  "deploy": {
    "placement": {
      "constraints": ["node.labels.role==controller"]
    }
  }
}
```

## 5) Confirm the constraint is working
```bash
# check where the task is scheduled
docker service ps my-ci-runner --no-trunc

# or for stacks
docker stack ps mystack --no-trunc
```
  docker node update --label-rm role swarm-wk-1
  docker service create --name npm --constraint 'node.labels.role==controller' jc21/nginx-proxy-manager:2.11.4
  ```
