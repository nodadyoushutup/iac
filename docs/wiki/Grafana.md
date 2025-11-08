# Grafana

End-to-end runbook for the Grafana Swarm stack that ships with both infrastructure (Docker provider) and configuration (Grafana provider) stages. Treat this guide as the authoritative reference once the plan in `docs/planning/grafana-plan.md` is complete.

## Overview

- **Service type:** App + config (Docker Swarm service + Grafana Terraform provider).
- **Purpose:** Visualize metrics scraped by Prometheus, starting with a Node Exporter overview dashboard and a managed Prometheus data source.
- **Key paths:** `terraform/module/grafana`, `terraform/module/grafana/config`, `terraform/swarm/grafana`, `pipeline/grafana.{sh,jenkins}`.

## Prerequisites

1. Access to the Swarm manager over SSH (matches other apps—see `provider_config.docker`).
2. Remote backend credentials in `~/.tfvars/minio.backend.hcl`.
3. A populated `~/.tfvars/grafana.tfvars` that includes:
   - `provider_config` → `docker` (host + ssh options) and `grafana` (URL, username, password). The service pulls the admin password directly from this block.
   - `grafana_config_inputs` → datasource definitions (folders + the starter Node Exporter dashboard are baked into Terraform defaults; append more entries only when you need to extend them).
4. Prometheus Swarm service reachable on the overlay network (defaults to `prometheus:9090`).

## TFVARS structure

Example (trimmed) from `~/.tfvars/grafana.tfvars`:

```hcl
provider_config = {
  docker = {
    host = "ssh://nodadyoushutup@192.168.1.22"
    ssh_opts = [...]
  }
  grafana = {
    url      = "http://grafana.internal:3000"
    username = "admin"
    password = "GrafanaAdminPass!"
  }
}

grafana_config_inputs = {
  datasources = [{
    name       = "Prometheus"
    uid        = "prometheus"
    type       = "prometheus"
    url        = "http://prometheus:9090"
    is_default = true
    json_data = { httpMethod = "POST" }
  }]
}
```

> Store sensitive values (passwords, API tokens, backend credentials) outside Git. The tfvars file stays local per the guidance in `AGENTS.md`.

## Bash pipeline (`pipeline/grafana.sh`)

```bash
./pipeline/grafana.sh \
  --tfvars ~/.tfvars/grafana.tfvars \
  --backend ~/.tfvars/minio.backend.hcl
```

Stages:
1. `terraform init` (handles backend migrations automatically).
2. **Grafana app plan/app** (`-target=module.grafana_app`, `-refresh=false`) – deploys the Swarm service, network, volume, secret.
3. **Grafana stack plan/app** – applies the entire stack so the Grafana provider provisions data sources/dashboards after the app is healthy.

Environment variables: inherits the helper scripts in `pipeline/script/*`, including optional Terraform output filtering and tfvars auto-discovery.

## Jenkins pipeline

- Job name: `grafana`
- Script path: `pipeline/grafana.jenkins`
- Parameters: `TFVARS_FILE`, `BACKEND_FILE` (both optional).

Trigger via the Jenkins UI once the tfvars/backend files exist on the agent (typically mounted via the shared NFS). The stage layout mirrors the bash script, so terraform logs look identical regardless of entrypoint.

## Updating dashboards or data sources

1. Add or edit entries under `grafana_config_inputs` in `~/.tfvars/grafana.tfvars`.
   - Most deployments just tweak datasources; Terraform already seeds the Infrastructure folder + Node Exporter dashboard. To add more, append to the `folders`/`dashboards` arrays and re-run the pipeline.
2. Rerun the pipeline (bash or Jenkins). Terraform will detect diffs and update Grafana via the provider.
3. For ad-hoc testing, you can run `terraform plan -target=module.grafana_config` inside `terraform/swarm/grafana`, but stick to the pipelines for consistency.

## Validation checklist

After each apply:

1. Verify the Swarm service is healthy:
   ```bash
   docker --host "${provider_config.docker.host}" service ps grafana --no-trunc
   ```
2. Hit the health endpoint:
   ```bash
   curl -sf http://grafana.internal:3000/api/health
   ```
   Expect `{"database":"ok","version":"11.x.x"}`.
3. Log in using the admin credentials defined in tfvars and confirm:
   - The Prometheus data source exists and passes the “Save & test” check.
   - The “Node Exporter Overview” dashboard appears under the *Infrastructure* folder.
4. Confirm users/dashboards survive restarts (volume mount `grafana-data` should persist on the Swarm node).

If anything fails, re-run the app-only stage with `terraform apply -target=module.grafana_app` to remediate container-level issues before touching config.

## Rollback / destroy

To remove Grafana entirely, run a targeted destroy from the stack directory:

```bash
cd terraform/swarm/grafana
terraform destroy -var-file ~/.tfvars/grafana.tfvars
```

Destroy will delete the Swarm service, overlay, volume, secrets, data sources, and dashboards. Export dashboards before destroying if you need to retain history.

## Troubleshooting

- **Backend/file discovery errors:** ensure the tfvars path exists or pass `--tfvars` / `--backend` explicitly.
- **Grafana provider auth failures:** confirm the admin username/password in `provider_config.grafana` match what the Swarm service booted with; mismatches often happen after a password rotation without updating tfvars.
- **Network connectivity:** if Grafana cannot reach Prometheus, double-check that `attach_prometheus_network = true` and the Prometheus stack is publishing the expected service alias.
- **Dashboard UID conflicts:** keep `uid` values unique across dashboards; Terraform/Grafana will reject duplicates.

## References

- Grafana Terraform provider documentation: <https://registry.terraform.io/providers/grafana/grafana/latest/docs>
- Deployment plan with historical context: `docs/planning/grafana-plan.md`
- Helper scripts used by all pipelines: `pipeline/script/*.sh`
