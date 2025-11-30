# NoDad Homelab

Welcome to the hub for the NoDad infrastructure stack. This repository is
evolving into a unified `homelab` project that centralizes automation,
configuration, and documentation for every platform service.

## What lives here

- **Machines & secrets** – Inventory, access, and credential locations. See [[Machines]] and [[Secrets]].
- **Access & trust** – SSH CA onboarding so hosts trust each other everywhere. See [[SSH-CA]].
- **Swarm workflows** – Taxonomy, pipelines, tfvars/backends, Jenkins job patterns. See [[Docker Swarm]] and [[Swarm-Node-Onboarding|Swarm Node Onboarding]].
- **Core stacks** – Jenkins, MinIO, Nginx Proxy Manager, Prometheus, Grafana, Graphite, Node Exporter. See their pages for Terraform/pipeline docs.
- **Runbooks & references** – Operational notes (labels, repo structure, planning docs).

## Getting started

1. Clone the repo: `git clone https://github.com/nodadyoushutup/homelab.git`
2. Install Docker and Docker Compose (required for MinIO bootstrap and local testing).
3. Review [[Repo Structure]] to learn where new infrastructure-as-code assets belong.
4. Run the provided scripts or pipelines before opening PRs to prove reproducibility.

## Table of contents

- [[Machines]] – host inventory, access, NFS.
- [[Secrets]] – tfvars/backends, kube configs, env files.
- [[SSH-CA]] – machine onboarding for host/user CA trust.
- [[Docker Swarm]] – workflows, pipelines, tfvars/backends, Jenkins job patterns.
- [[Swarm-Node-Onboarding|Swarm Node Onboarding]] – manual checklist to add Swarm nodes without automation.
- [[Repo Structure]] – layout and conventions.
- [[Jenkins]] – CI/CD images and deployment via Terraform/pipelines.
- [[MinIO]] – Terraform backend via Docker Compose.
- [[Nginx-Proxy-Manager]] – app + config Terraform stages.
- [[Prometheus]] – inline-config Swarm service.
- [[Grafana]] – app + config provider stages.
- [[Graphite]] – app-only Swarm service.
- [[Node-Exporter]] – global Swarm exporter.
- [[Docker-Node-Labels|Docker Node Labels]] – label strategy and commands.

## Roadmap toward `homelab`

Core Swarm stacks (Jenkins, Nginx Proxy Manager, Prometheus, Grafana, Graphite, Node Exporter) now ship with Terraform modules and pipelines. Continued work focuses on:

- Hardening/expanding observability (dashboards, alerts, logging pipelines).
- Tightening CI/CD around Terraform changes and Jenkins job provisioning.
- Keeping documentation and runbooks current for every managed service.

Contributions should follow an "infrastructure as product" mindset—every new
component needs automation, documentation, and reproducible workflows.

## Need something?

Open a GitHub issue or drop a note in team chat. This wiki should change often,
so add context as soon as you learn it.
