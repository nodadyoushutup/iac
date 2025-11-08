# Node Exporter Deployment Plan

Plan for introducing a Docker Swarm–wide Node Exporter service that mirrors the Dozzle deployment patterns (Terraform module + stack, bash + Jenkins pipelines) with only the functional deltas needed for Prometheus scraping.

## Goals & Constraints
- Reuse the Dozzle scaffolding wherever possible so contributors can diff the two implementations easily.
- Run one Node Exporter task per Swarm node (`mode.global = true`) using the official `prom/node-exporter` image (pinned by tag + digest).
- Mount the host metrics paths read-only and expose port `9100` through the ingress network; no Docker socket access is required.
- Assume a provider block defined via `~/.tfvars/node_exporter.tfvars`. Backend config still comes from `~/.tfvars/minio.backend.hcl`.
- Deliver both a bash pipeline (`pipeline/node_exporter.sh`) and a Jenkins pipeline (`pipeline/node_exporter.jenkins`) plus a Jenkins job so operators can trigger either path identically to Dozzle.

## Stage 0 – Preparation & Baseline
- [x] Catalog all Dozzle touchpoints we plan to mirror:
  - Terraform module: `terraform/module/dozzle/{main.tf,variables.tf,provider.tf}` (declares the `docker_network` + `docker_service` resources).
  - Stack wrapper: `terraform/dozzle/{main.tf,variables.tf,provider.tf}` (wire-up for remote state + provider config map).
  - Pipelines: `pipeline/dozzle.sh` (bash) and `pipeline/dozzle.jenkins` (Jenkinsfile).
  - Jenkins integration: `terraform/module/jenkins/config/{main.tf,job/dozzle.xml.tmpl}` provisions the Jenkins job that runs the pipeline script.
  - Ancillary tooling: Dozzle also has a `docker/dozzle/purge.sh`, but it is not referenced by the Terraform/pipeline flow, so we can ignore it for Node Exporter.
- [x] Document Dozzle helper scripts to keep behavior identical:
  - `pipeline/script/env_check.sh` validates prerequisites, discovers `python3`, and exposes `PYTHON_CMD`, `FILTER_SCRIPT`, and `FILTER_AVAILABLE` environment variables consumed downstream.
  - `pipeline/script/resolve_inputs.sh` centralizes tfvars/backend discovery with fallbacks to `~/.tfvars`, reducing per-app boilerplate.
  - `pipeline/script/terraform_exec.sh` wraps Terraform commands to optionally pipe through `terraform_output_filter.py` for clean logs; both bash and Jenkins pipelines source it.
  - Conclusion: the new pipelines should keep calling these scripts rather than re-implementing their logic; only default values (TFVARS basename, Terraform dir) need to change.
- [x] Decide on concrete Node Exporter container settings:
  - Image: `docker.io/prom/node-exporter:v1.7.0@sha256:4cb2b9019f1757be8482419002cb7afe028fdba35d47958829e4cfeaf6246d80` (multi-arch manifest digest from `docker buildx imagetools inspect`).
  - Command args: `--path.procfs=/host/proc --path.sysfs=/host/sys --path.rootfs=/host/rootfs --collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($|/)" --collector.filesystem.ignored-fs-types="^(autofs|proc|sysfs|tmpfs|devtmpfs|devpts|overlay|aufs)$"`.
  - Bind mounts (read-only unless noted): `/proc:/host/proc:ro`, `/sys:/host/sys:ro`, `/:/host/rootfs:ro`, plus `/etc/hostname` as a read-only file mount so metrics expose the node name consistently.
  - Networking/ports: keep a dedicated overlay network named `node-exporter` for parity with Dozzle, expose container port `9100` as published port `9100` via ingress.
  - Service mode: `global = true`, same platform constraint as Dozzle (linux/arm64) for now; can be relaxed later if mixed-arch workers join the Swarm.

## Stage 1 – Terraform Module (`terraform/module/node_exporter`)
- [x] Copy the Dozzle module skeleton and rename resources, variables, and locals to `node_exporter`.
- [x] Keep `provider_config` input semantics identical so the module plugs into existing provider wiring (`terraform/module/node_exporter/variables.tf` mirrors Dozzle).
- [x] Replace the `docker_service` container spec with Node Exporter needs (`terraform/module/node_exporter/main.tf`):
  - Image pinned to `docker.io/prom/node-exporter:v1.7.0@sha256:4cb2b9019f1757be8482419002cb7afe028fdba35d47958829e4cfeaf6246d80`.
  - Args provide the `/host/*` overrides and filesystem ignore patterns listed in Stage 0.
  - Bind mounts added for `/proc`, `/sys`, `/` (rootfs), and `/etc/hostname`, all read-only; the Docker socket mount was removed.
  - Port 9100 exposed/published via the existing overlay network, keeping Dozzle-style `mode.global` scheduling.
- [x] Keep `docker_network` creation (named `node-exporter`) so the service mirrors Dozzle’s isolated overlay instead of relying purely on `ingress`.
- [x] Provide observability labels via the `docker_service` `labels` map (`com.docker.stack.namespace` + `com.docker.service`).

## Stage 2 – Stack Definition (`terraform/node_exporter`)
- [x] Duplicate the Dozzle stack layout (provider.tf, variables.tf, main.tf) changing backend key to `node_exporter.tfstate` (`terraform/node_exporter/*` mirrors Dozzle 1:1).
- [x] Wire `module "node_exporter_app"` to `../module/node_exporter` and thread `var.provider_config` so the module consumes the same provider map as Dozzle.
- [x] `.terraform.lock.hcl` is intentionally omitted just like `terraform/dozzle` (root-level locking still handles provider pinning), so no extra file was added.
- [x] Added a “Swarm application pattern” section to `README.md` documenting that Node Exporter and Dozzle share the same module/stack/pipeline structure and should be cloned for future apps.

## Stage 3 – TFVARS & Provider Glue
- [x] Expect operators to create `~/.tfvars/node_exporter.tfvars` with the same schema as Dozzle and document it: the README now lists Node Exporter in the TFVARS defaults table alongside Jenkins/Dozzle.
- [x] No changes needed in `pipeline/script/resolve_inputs.sh`; it already supports per-stack `DEFAULT_TFVARS_BASENAME` overrides that the upcoming pipelines will pass in.
- [x] Backend discovery remains `~/.tfvars/minio.backend.hcl`, matching the other stacks (and captured in the README table), so no code changes were required.

## Stage 4 – Bash Pipeline (`pipeline/node_exporter.sh`)
- [x] Copy `pipeline/dozzle.sh` verbatim into `pipeline/node_exporter.sh` and rename identifiers/logging to `node_exporter`.
- [x] Update `TERRAFORM_DIR` to `terraform/node_exporter` plus `DEFAULT_TFVARS_BASENAME=node_exporter` and `DEFAULT_TFVARS_FILE=$HOME/.tfvars/node_exporter.tfvars`.
- [x] Helper usage remains identical (`env_check.sh`, `resolve_inputs.sh`, `terraform_exec.sh`); only per-stack defaults were changed.
- [x] Stage banners and the final `[DONE]` message now reference Node Exporter so operators can distinguish runs in shared consoles.

## Stage 5 – Jenkins Pipeline & Job
- [x] Created `pipeline/node_exporter.jenkins` by cloning the Dozzle pipeline and swapping terraform paths, stage labels, and TFVARS defaults to `node_exporter`.
- [x] Updated `terraform/module/jenkins/config/main.tf` to ingest the new pipeline file and provision a `jenkins_job.node_exporter` resource.
- [x] Added `terraform/module/jenkins/config/job/node_exporter.xml.tmpl`, mirroring Dozzle’s job template but pointing at `pipeline/node_exporter.jenkins` with the appropriate description/parameters (same `TFVARS_FILE` / `BACKEND_FILE` pair as the bash script).
- [x] Result: Jenkins now exposes a first-class job that executes the Node Exporter pipeline with identical ergonomics to Dozzle.

## Stage 6 – Validation, Docs, and Follow-ups
- [x] Documented validation + run instructions in `docs/wiki/Node-Exporter.md`, including bash pipeline commands, Jenkins job usage, Prometheus scrape examples, and steps to change the published port.
- [x] Due to missing tfvars/backend secrets in the repo, Terraform wasn’t applied here; operators should run `pipeline/node_exporter.sh --tfvars ~/.tfvars/node_exporter.tfvars --backend ~/.tfvars/minio.backend.hcl` (plus trigger the Jenkins `node_exporter` job) following the runbook to validate in their environment.
- [x] Captured follow-up ideas (shared module abstractions, parameterized ports) in the runbook so future contributors can tackle cleanup once on-cluster validation succeeds.
