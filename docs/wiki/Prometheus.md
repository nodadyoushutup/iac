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

## Bash pipelines

Pick the stage that matches the change in flight—most rollouts run the app stage first (to deploy/update the container) and the config stage when `prometheus_config` changes.

### App stage (`pipeline/prometheus/app.sh`)

```bash
cd /path/to/homelab
./pipeline/prometheus/app.sh \
  --tfvars ~/.tfvars/prometheus.tfvars \
  --backend ~/.tfvars/minio.backend.hcl
```

- Shared helpers verify Terraform availability and resolve input paths.
- `terraform init/plan/apply` runs against `terraform/swarm/prometheus`, updating the service, network, and volume definitions.

### Config stage (`pipeline/prometheus/config.sh`)

```bash
cd /path/to/homelab
./pipeline/prometheus/config.sh \
  --tfvars ~/.tfvars/prometheus.tfvars \
  --backend ~/.tfvars/minio.backend.hcl
```

- Reuses the helper workflow from the app stage.
- `terraform plan/apply -target=docker_config.prometheus` refreshes only the rendered `prometheus.yml` Docker config so you can push scrape/config changes without recycling the container.

### Validation checklist

- `docker service ls | grep prometheus` shows `Replicated: 1/1`.
- `docker service ps prometheus --no-trunc` confirms the task is running on a monitoring-labeled node.
- `curl http://swarm-cp-0.internal:9090/targets` (or via ingress IP) lists all Node Exporter targets as `UP`.
- `curl -X POST http://swarm-cp-0.internal:9090/-/reload` reloads config without redeploying (thanks to `--web.enable-lifecycle`).

## Jenkins pipelines

1. Run `prometheus/app` for Swarm-level changes or `prometheus/config` for config-only updates (both jobs live under the `prometheus` folder).
2. Override `TFVARS_FILE` / `BACKEND_FILE` only if the defaults differ; the jobs point at `pipeline/prometheus/app.jenkins` and `pipeline/prometheus/config.jenkins` respectively.
3. Trigger the build; the Jenkins templates mirror the bash stages (Env Check → Resolve Inputs → Init → Plan → Apply) and emit identical Terraform logs.

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
