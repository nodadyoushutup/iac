# Prometheus Deployment Plan

Plan for introducing a Docker Swarm–based Prometheus stack that scrapes the Node Exporter endpoints we just deployed. The deliverables mirror the Node Exporter effort: Terraform module + stack, bash + Jenkins pipelines, and runbooks so operators can manage everything consistently.

## Goals & Constraints
- Reuse the Dozzle/Node Exporter scaffolding so diffs stay reviewable and every app stack looks/behaves the same.
- Prometheus runs as a Swarm service (single replica on the control-plane node) with a dedicated overlay network and persistent volume for TSDB data.
- Config is source-controlled via Terraform: `prometheus_config` (from `~/.tfvars/prometheus.tfvars`) is serialized with `yamlencode` into a Docker config à la Jenkins CasC so editing scrape targets never requires rebuilding the container image.
- Pipelines must support the same helper scripts (`env_check.sh`, `resolve_inputs.sh`, `terraform_exec.sh`) and default to `~/.tfvars/prometheus.tfvars` + `~/.tfvars/minio.backend.hcl`.
- Node Exporter targets are static FQDNs (`swarm-cp-0.internal`, `swarm-wk-0.internal`, … `swarm-wk-3.internal`) on port `9100`; the initial config should seed these so Prometheus is useful immediately.

## Stage 0 – Preparation & Baseline
- [x] Inventory reusable Terraform pieces:
  - Service module template: `terraform/module/node_exporter` (network + service wiring) gives us the structure for networks, mounts, and provider handling.
  - Config templating reference: `terraform/module/jenkins/app/controller` shows how to `yamlencode` structured input, create a `docker_config`, and mount it into a service—exactly what we need for Prometheus rules.
  - Stack + pipeline scaffolding: `terraform/node_exporter`, `pipeline/node_exporter.sh`, and `pipeline/node_exporter.jenkins` supply the boilerplate we’ll copy for Terraform wrapper + bash/Jenkins entrypoints.
  - Jenkins config module (`terraform/module/jenkins/config`) already provisions jobs for Dozzle/Node Exporter; we’ll add Prometheus there to keep CI consistent.
- [x] Decide on Prometheus container details up front:
  - Image: `docker.io/prom/prometheus:v2.51.0@sha256:5ccad477d0057e62a7cd1981ffcc43785ac10c5a35522dc207466ff7e7ec845f` (linux/arm64 manifest available via `docker buildx imagetools inspect`).
  - Command flags: `--config.file=/etc/prometheus/prometheus.yml`, `--storage.tsdb.path=/prometheus`, `--storage.tsdb.retention.time=15d`, `--web.enable-lifecycle` so we can POST `/-/reload`.
  - Storage: dedicated Docker volume `prometheus-data` mounted at `/prometheus` for TSDB + a Docker config that writes `prometheus.yml` into `/etc/prometheus`.
  - Networking: overlay network `prometheus` plus ingress-published port `9090` (matches the default web UI + API).
  - Placement: single replica constrained to nodes labeled `role=monitoring` (`constraints = ["node.labels.role==monitoring"]`) and platform `linux/arm64`, mirroring how Jenkins agents pin to `role=cicd`.

## Stage 1 – Terraform Module (`terraform/module/prometheus`)
- [x] Scaffolded provider + variable files so the module accepts both `provider_config` and `prometheus_config`.
- [x] Added locals to `yamlencode` the config, compute a SHA, and expose it via `output.prometheus_config_sha` for change tracking.
- [x] Implemented resources:
  - `docker_network.prometheus`, `docker_volume.prometheus_data`, and `docker_config.prometheus`.
  - `docker_service.prometheus` (single replica) pinned to `node.labels.role==monitoring`, using the pinned image, args, config mount, volume mount, healthcheck, ingress port 9090, and consistent labels.
- [x] Output now advertises the config SHA for observability/automation.

## Stage 2 – Stack Definition (`terraform/prometheus`)
- [x] Duplicated the Node Exporter stack skeleton into `terraform/prometheus` with backend key `prometheus.tfstate`.
- [x] `module "prometheus_app"` now points to `../module/prometheus`, passing through both `provider_config` and `prometheus_config`.
- [x] No `.terraform.lock.hcl` was added, matching the existing stack conventions.
- [x] README’s Swarm pattern and TFVARS table now mention Prometheus so operators know about the new stack/defaults.

## Stage 3 – TFVARS & Config Input
- [x] No changes required in `pipeline/script/resolve_inputs.sh`; per-pipeline defaults already support a `DEFAULT_TFVARS_BASENAME` that we’ll set to `prometheus`.
- [x] Pre-seeded `~/.tfvars/prometheus.tfvars` with:
  - `provider_config` identical to other Docker stacks.
  - `prometheus_config` map with:
    ```hcl
    global = {
      scrape_interval     = "15s"
      evaluation_interval = "15s"
    }
    scrape_configs = [{
      job_name        = "node_exporter"
      metrics_path    = "/metrics"
      static_configs = [{
        targets = [
          "swarm-cp-0.internal:9100",
          "swarm-wk-0.internal:9100",
          "swarm-wk-1.internal:9100",
          "swarm-wk-2.internal:9100",
          "swarm-wk-3.internal:9100",
        ]
      }]
    }]
    ```
  - Additional knobs (retention, external labels) can live here later; Terraform just serializes whatever structure we pass.
- [x] README TFVARS table now lists `~/.tfvars/prometheus.tfvars`, so operators know the default path before pipelines exist.

## Stage 4 – Bash Pipeline (`pipeline/prometheus.sh`)
- [x] Copied `pipeline/node_exporter.sh` → `pipeline/prometheus.sh`, updated identifiers/logging to `prometheus`.
- [x] Defaults now point at `terraform/prometheus` + `~/.tfvars/prometheus.tfvars` (backend default unchanged).
- [x] Helper usage and environment exports remain untouched; script is functionally identical aside from per-stack strings.

## Stage 5 – Jenkins Pipeline & Job
- [x] Cloned `pipeline/node_exporter.jenkins` into `pipeline/prometheus.jenkins`, swapping Terraform paths, default tfvars, and stage titles.
- [x] `terraform/module/jenkins/config` now imports the new pipeline, and provisions `jenkins_job.prometheus` with a dedicated XML template.
- [x] `terraform/module/jenkins/config/job/prometheus.xml.tmpl` mirrors the existing job templates but points at `pipeline/prometheus.jenkins`; parameters remain `TFVARS_FILE` / `BACKEND_FILE`.

## Stage 6 – Validation, Docs, and Follow-ups
- [x] Added `docs/wiki/Prometheus.md` detailing prerequisites, bash/Jenkins deployment steps, validation checklist, scrape config editing, and runtime tweaks (ports, retention, reload endpoint).
- [x] Jenkins job + bash pipeline are ready; actual deploy/validation should be run by operators with access to `~/.tfvars/prometheus.tfvars` and the Swarm (`./pipeline/prometheus.sh --tfvars ~/.tfvars/prometheus.tfvars --backend ~/.tfvars/minio.backend.hcl` plus triggering the Jenkins `prometheus` job).
- [x] Captured future enhancements in the runbook (Alertmanager/Grafana follow-ups, parameterized constraints/scrape targets) so they remain visible post-launch.
