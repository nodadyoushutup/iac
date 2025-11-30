# Wiki Audit Plan

Goal: clean up factual errors and outdated guidance across the wiki, focusing on the items flagged in the latest review.

## Stage 0 – Preparation
- [x] Confirm target docs exist: `docs/wiki/Home.md`, `Repo-Structure.md`, `MinIO.md`, `Jenkins.md`, `Nginx-Proxy-Manager.md`, `Prometheus.md`, `Docker-Node-Labels.md`.
- [x] Collect current source-of-truth values (constraints, images, labels, paths) from Terraform/pipelines:
  - [x] NPM image + placement: `terraform/module/nginx_proxy_manager/app/main.tf` pins `jc21/nginx-proxy-manager:2.12.6@sha256:6ab097814f54b1362d5fd3c5884a01ddd5878aaae9992ffd218439180f0f92f3` with constraint `node.labels.role==controller`.
  - [x] Prometheus placement constraint: `terraform/module/prometheus/main.tf:61` uses `constraints = ["node.labels.role==controller"]`.
  - [x] Node label reality: `docs/wiki/Machines.md` reflects current roles — wk-0=cicd, wk-1=database, wk-2=monitoring, wk-3=edge; controller unlabeled; truenas/proxmox added; architectures captured.
  - [x] MinIO compose path: `docker/state/docker-compose.yaml` with `.env` in the same dir (not `docker/minio/.env`); runs on `medusa.internal` (aarch64).
- [x] Decide desired repo clone URL and roadmap language for `Home.md`: use `https://github.com/nodadyoushutup/homelab.git`; roadmap should reflect existing Terraform modules/pipelines rather than “upcoming.”
- [x] Decide updated repo tree for `Repo-Structure.md`: include `docker/state` (MinIO/Renovate compose), `docker/purge/*`, service pipelines under `pipeline/`, Terraform modules/stacks under `terraform/module/*` and `terraform/swarm/*`, docs/planning, and AGENTS as a doc directory pointer (not a Jenkins agent catalog).
- [x] Confirm Jenkins deployment workflow: images built via GH Actions (`.github/workflows/jenkins_*_build_push.yml`); deployment is Terraform/pipeline-driven (no local build scripts, no compose stack for Jenkins in repo); purge script lives under `docker/purge/jenkins.sh`.

## Stage 1 – Edits
- [x] Update `Home.md` clone URL and roadmap to reflect current homelab state.
- [x] Rewrite `Repo-Structure.md` tree/conventions to match the current repo layout and AGENTS role.
- [x] Fix `MinIO.md` bootstrapping paths to `docker/state/.env` and current compose location.
- [x] Refresh `Jenkins.md` to remove nonexistent build/compose steps and align with Terraform/pipeline deployment and purge script location.
- [x] Correct `Nginx-Proxy-Manager.md` image version and placement constraint; align validation text.
- [x] Correct `Prometheus.md` placement constraint language.
- [x] Update `Docker-Node-Labels.md` node map and usage examples to match current labels (wk-0=cicd, wk-1=database, wk-2=monitoring, wk-3=edge; controller unlabeled) and remove stray/duplicated lines.

## Stage 2 – Validation & wrap-up
- [x] Re-read all modified wiki pages for factual accuracy against code/pipelines.
- [x] Run link/anchor sanity check (manual skim) to ensure sidebar and page cross-links still resolve.
- [x] Summarize changes back to AGENTS/Machines if any cross-references need tweaks (no changes needed).
