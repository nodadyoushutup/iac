# Nginx Proxy Manager

Reverse proxy automation for edge HTTP/S workloads. The stack follows the **App + config** taxonomy from `AGENTS.md`, so Terraform first deploys the containerized service to Swarm and then applies API-driven proxy/certificate resources once the UI is reachable.

## Architecture

- **App stage** – `terraform/module/nginx_proxy_manager/app` provisions the Swarm service, overlay network, and persistent volumes. It pins `jc21/nginx-proxy-manager:2.13.2@sha256:342e8cfa…` and constrains placement to nodes labeled `role=edge` (see [[Docker Node Labels]]) so perimeter services stay isolated.
- **Config stage** – `terraform/module/nginx_proxy_manager/config` uses the [`Sander0542/nginxproxymanager`](https://registry.terraform.io/providers/Sander0542/nginxproxymanager/latest/docs) provider to manage certificates, proxy hosts, and access lists. It consumes the app stage’s remote state to reference stack metadata but writes all runtime config through the API.
- **State storage** – both stages use the shared MinIO backend defined in `~/.tfvars/minio.backend.hcl`. The config stage exports `TF_VAR_remote_state_backend` (parsed from that file) so `data "terraform_remote_state"` can fetch `nginx-proxy-manager-app.tfstate` without copy/pasting credentials.
- **Pipelines/Jenkins** – `pipeline/nginx_proxy_manager/{app,config}.{sh,jenkins}` run through `pipeline/script/swarm_pipeline.sh`. Jenkins jobs live under the `nginx_proxy_manager` folder once `terraform/module/jenkins/config` is applied.

## Terraform surfaces

| Stage | Directory | Highlights |
|-------|-----------|------------|
| App | `terraform/module/nginx_proxy_manager/app` + `terraform/swarm/nginx_proxy_manager/app` | Creates overlay network, data/LE volumes, Swarm service with `/usr/bin/check-health`, outputs stack namespace/ports. |
| Config | `terraform/module/nginx_proxy_manager/config` + `terraform/swarm/nginx_proxy_manager/config` | Declares certificates, proxy hosts, and access lists via provider resources. Validates that the app state is present before apply. |

> Streams and redirections have typed inputs in `variables.tf` but are intentionally left empty until we have concrete workloads. Extend the existing schema and reference provider docs when you enable them.

## Tfvars & secrets

| File | Purpose | Notes |
|------|---------|-------|
| `~/.tfvars/nginx-proxy-manager/app.tfvars` | Docker host SSH details (`provider_config.docker`) and bootstrap secrets (`secrets` map for admin email/password/API token, ACME email, JWT secret). Only secrets live here; networks/ports/node labels are fixed in locals. |
| `~/.tfvars/nginx-proxy-manager/config.tfvars` | `provider_config.nginx_proxy_manager` (URL + credentials) and declarative `config` payload for certificates, proxy hosts, access lists, streams, and redirections. |
| `~/.tfvars/minio.backend.hcl` | Shared backend definition. The config pipeline parses this file to export `TF_VAR_remote_state_backend` (JSON) so Terraform can read the app state. Override with `--backend` if you use a different file. |

Verify the structure with:

```bash
ls -l ~/.tfvars/nginx-proxy-manager
python3 - <<'PY'
from pathlib import Path
path = Path.home()/'.tfvars'/'nginx-proxy-manager'/'app.tfvars'
for idx,line in enumerate(path.read_text().splitlines(), 1):
    if idx > 20: break
    if '=' in line and not line.strip().startswith('#'):
        print(line.split('=')[0].rstrip(), '= ***redacted***')
    else:
        print(line)
PY
```

(Any redaction helper works; the goal is to prove keys exist without leaking secrets.)

## Pipelines & Jenkins jobs

| Stage | Script | Jenkins job | Default inputs |
|-------|--------|-------------|----------------|
| App | `pipeline/nginx_proxy_manager/app.sh` | `nginx_proxy_manager-app` | `~/.tfvars/nginx-proxy-manager/app.tfvars`, backend `~/.tfvars/minio.backend.hcl` |
| Config | `pipeline/nginx_proxy_manager/config.sh` | `nginx_proxy_manager-config` | `~/.tfvars/nginx-proxy-manager/config.tfvars`, backend `~/.tfvars/minio.backend.hcl` (also consumed to derive `TF_VAR_remote_state_backend`) |

Both shell stages accept `--tfvars` and `--backend` overrides. The config wrapper’s `pipeline_pre_terraform()` performs two safety checks before running `swarm_pipeline.sh`:

1. Parses the backend file into JSON and exports `TF_VAR_remote_state_backend`.
2. Runs `terraform init` + `terraform state pull` against the app stack to ensure `nginx-proxy-manager-app.tfstate` exists. If the app has never been applied, the config stage exits with a helpful error.

## Operations & runbook

- **Deploy/Update** – run the app pipeline first (`--plan` or Jenkins job) to roll out image changes or placement tweaks. Once the service is healthy (`docker service ps nginx-proxy-manager --no-trunc`), run the config pipeline to apply certificates/hosts.
- **Adding proxy hosts** – extend the `config.tfvars` `proxy_hosts` list; use `certificate` to reference a named certificate in the same tfvars file. Access lists can be referenced by ID or by name (the module maps names to IDs automatically).
- **Rotating admin secrets** – update the `secrets` map in `app.tfvars` and re-run the app pipeline. The module rewrites the container env vars; follow up in config tfvars if API credentials changed.
- **Troubleshooting**:
  - `terraform plan` fails in config stage: confirm `TF_VAR_remote_state_backend` is set (script logs the derived JSON) and that the app pipeline has been applied.
  - Jenkins job missing: run `pipeline/jenkins/config.sh --plan` or `terraform -chdir=terraform/swarm/jenkins/config plan -var-file ~/.tfvars/jenkins/config.tfvars` to add the multi-stage folder/jobs.
  - Service placement issues: ensure the target nodes still carry `role=edge` (`docker node ls --format '{{.Hostname}} {{.Spec.Labels}}'`).

## Validation matrix

| Persona | Test | Status | Notes |
|---------|------|--------|-------|
| Agent | `TF_LOG=INFO pipeline/nginx_proxy_manager/app.sh --plan` (auto apply) | ✅ | `terraform` init/plan/apply completed; outputs under `/tmp/npm_app_plan.log`. |
| Agent | `docker service ls` / `docker service ps nginx-proxy-manager --no-trunc` | ⚠️ | Swarm reports `0/1` replicas – no node currently satisfies `node.labels.role==edge`. Label `swarm-wk-1` (or another edge node) before rerunning config stage. |
| Agent | `TF_LOG=INFO pipeline/nginx_proxy_manager/config.sh --plan` | ⚠️ | Plan fails with `lookup npm.example.com: no such host`; replace placeholder URL in `~/.tfvars/nginx-proxy-manager/config.tfvars` with a reachable NPM endpoint before retrying. |
| Human | Run Jenkins jobs `nginx_proxy_manager-app` / `nginx_proxy_manager-config` | ⏳ | Pending – requires Jenkins credentials once pipelines are wired into CI. |
| Human | Hit `https://<npm-domain>:81` and verify proxy hosts | ⏳ | Perform after config plan succeeds and Swarm exposes the service on an edge-labeled node. Document screenshots or curl output in the planning doc. |

## Reference links

- Container image: [`jc21/nginx-proxy-manager`](https://hub.docker.com/r/jc21/nginx-proxy-manager)
- Terraform provider: [`Sander0542/nginxproxymanager`](https://registry.terraform.io/providers/Sander0542/nginxproxymanager/latest/docs)
- Upstream docs: <https://nginxproxymanager.com/setup/>
