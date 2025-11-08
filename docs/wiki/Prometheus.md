# Prometheus

Prometheus runs as a Docker Swarm service (single replica on a monitoring node) and scrapes the Node Exporter instances we deployed earlier. Terraform manages both the service definition and the rendered `prometheus.yml` so scrape targets stay version-controlled.

## Prerequisites

- MinIO/S3 backend config at `~/.tfvars/minio.backend.hcl`.
- `~/.tfvars/prometheus.tfvars` containing both the Docker provider config and a `prometheus_config` block. Example:

```hcl
provider_config = {
  docker = {
    host = "ssh://nodadyoushutup@192.168.1.22"
    ssh_opts = [
      "-o", "StrictHostKeyChecking=no",
      "-o", "UserKnownHostsFile=/dev/null",
      "-i", "~/.ssh/id_rsa"
    ]
  }
}

prometheus_config = {
  global = {
    scrape_interval     = "15s"
    evaluation_interval = "15s"
  }

  scrape_configs = [{
    job_name     = "node_exporter"
    metrics_path = "/metrics"
    static_configs = [{
      targets = [
        "swarm-cp-0.internal:9100",
        "swarm-wk-0.internal:9100",
        "swarm-wk-1.internal:9100",
        "swarm-wk-2.internal:9100",
        "swarm-wk-3.internal:9100"
      ]
    }]
  }]
}
```

Add more jobs/targets to `prometheus_config` as needed; Terraform serializes the entire structure into a Docker config.

## Deploy via bash pipeline

```bash
cd /path/to/homelab
./pipeline/prometheus.sh \
  --tfvars ~/.tfvars/prometheus.tfvars \
  --backend ~/.tfvars/minio.backend.hcl
```

Pipeline stages:
1. Environment + input resolution via shared helper scripts.
2. `terraform init/plan/apply` within `terraform/swarm/prometheus`.
3. Docker creates the `prometheus` overlay network, TSDB volume, config, and service pinned to nodes with `role=monitoring`, publishing `:9090`.

### Validation checklist

- `docker service ls | grep prometheus` shows `Replicated: 1/1`.
- `docker service ps prometheus --no-trunc` confirms the task is running on a monitoring-labeled node.
- `curl http://swarm-cp-0.internal:9090/targets` (or via ingress IP) lists all Node Exporter targets as `UP`.
- `curl -X POST http://swarm-cp-0.internal:9090/-/reload` reloads config without redeploying (thanks to `--web.enable-lifecycle`).

## Deploy via Jenkins

1. Open the `prometheus` job (sibling to `dozzle` / `node_exporter`).
2. Optionally override `TFVARS_FILE` or `BACKEND_FILE`; otherwise defaults mirror the bash script.
3. Trigger a build; stages (Env Check → Resolve Inputs → Init → Plan → Apply) match the CLI pipeline and reuse the same helper scripts.

## Editing scrape configs

1. Update the `prometheus_config` map inside your tfvars file (add new jobs, relabel targets, tweak scrape intervals).
2. Re-run the pipeline (bash or Jenkins). Terraform detects the config change, uploads a new Docker config, and rolling-updates the service.
3. Use `curl http://<host>:9090/-/config` or the UI to verify changes.

## Changing ports or persistence

- To adjust the Prometheus web port, edit `endpoint_spec.ports` in `terraform/module/prometheus/main.tf`.
- To change TSDB retention or flags, edit the `args` list in the same file.
- Re-run the pipeline to roll out changes; remember to update firewalls and any load balancers.

## Follow-up ideas

- Introduce Alertmanager and/or Grafana using the same Terraform/pipeline pattern for a full observability suite.
- Parameterize the node constraint or published port via module variables if future environments differ.
- Consider templating scrape targets from a list of nodes defined in tfvars to avoid duplicating hostnames.
