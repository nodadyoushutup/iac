<div align="center">
  <img src="docs/img/avatar.png" alt="NoDad Homelab avatar" width="400" />
  <h1>NoDad Homelab</h1>
  <p><strong>All of the infrastructure-as-code that powers the NoDad homelab—codified, versioned, and reproducible.</strong></p>
  <p>
    <a href="https://github.com/NoDadYouShutUp/homelab/wiki">📘 Full Wiki</a> ·
    <a href="docs">🗂 Docs Folder</a> ·
    <a href="terraform">🔧 Terraform</a> ·
    <a href="pipeline">🚀 CI/CD</a>
  </p>
</div>

## Overview

This repo is the single source of truth for networking, compute, storage, automation, observability, and the application services that make up the NoDad homelab. Terraform, Docker, Jenkins, and supporting scripts live side-by-side so the entire environment can be stood up, torn down, and iterated via Git.

## Highlights

- **Infrastructure as Code first**: Terraform modules, Docker images, and automation scripts live here so infra changes are reviewed just like app code.
- **Reproducible environments**: Pipelines and bootstrap scripts ensure the homelab can be rebuilt from scratch with predictable outcomes.
- **Observability baked in**: Logging/metrics dashboards and alerting configs are tracked to keep operations transparent.
- **Wiki as the playbook**: Deep dives, runbooks, and design rationales are maintained in the wiki and evolve alongside the code.

## Repository Layout

```text
.
├─ terraform/          # Core IaC modules, workspaces, and tfvars references
├─ docker/             # Container builds and supporting assets
├─ pipeline/           # Jenkins and CI/CD definitions
├─ docs/               # Visuals, diagrams, and supplemental notes
└─ remove-terraform-dirs.sh  # Cleanup helper for local state directories
```

## Getting Started

1. Install the baseline tooling: Terraform, Docker, and a shell with `bash` available.
2. Clone this repository and review `AGENTS.md` for machine-specific secrets locations.
3. Follow the environment-specific bootstrap guide in the [wiki](https://github.com/NoDadYouShutUp/homelab/wiki) to wire credentials, backend state, and pipelines.

Once the prerequisites are in place, use the wiki’s runbooks for day-to-day operations (planning/applying Terraform, rotating secrets, updating services, etc.).

## Documentation

The README stays high-level by design. For architecture diagrams, module deep dives, operational runbooks, and troubleshooting tips, head directly to the [project wiki](https://github.com/NoDadYouShutUp/homelab/wiki). It is the authoritative source of truth for everything beyond this overview.
