<table align="center">
  <tr>
    <td valign="middle">
      <img src="docs/img/avatar.png" alt="NoDad Homelab avatar" width="180" />
    </td>
    <td valign="middle" style="padding-left: 18px;">
      <h1>NoDad Homelab</h1>
      <p><strong>All of the infrastructure-as-code that powers the NoDad homelab—codified, versioned, and reproducible.</strong></p>
      <p>
        <a href="https://github.com/NoDadYouShutUp/homelab/wiki">📘 Full Wiki</a> ·
        <a href="docs">🗂 Docs Folder</a> ·
        <a href="terraform">🔧 Terraform</a> ·
        <a href="pipeline">🚀 CI/CD</a>
      </p>
    </td>
  </tr>
</table>

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
│  └─ remove-terraform-dirs.sh  # Cleanup helper for local state directories
├─ docker/             # Container builds and supporting assets
├─ pipeline/           # Jenkins and CI/CD definitions
└─ docs/               # Visuals, diagrams, and supplemental notes
```

### Swarm application pattern

Each Docker Swarm app (currently Dozzle, Node Exporter, Prometheus, and Grafana) follows the same layout to keep review diffs minimal:

- `terraform/module/<app>` defines the reusable service module (network + `docker_service`).
- `terraform/<app>` is the stack entrypoint that configures the backend, provider, and references the module. Grafana’s stack also wires in the Grafana Terraform provider so dashboards/data sources deploy right after the Docker service is healthy.
- Matching pipelines live under `pipeline/` (bash + Jenkins) so both services inherit identical tooling and helper scripts.

When introducing the next app, copy one of the existing stacks wholesale and only change the service-specific pieces. This keeps Terraform state keys, provider wiring, and pipeline ergonomics predictable.

### TFVARS defaults

Helper scripts look in `~/.tfvars` for stack-specific variable files unless a path is provided. Keep these files in sync with their keyed Terraform backends:

| Stack          | Default TFVARS path                | Backend config (default)             |
|----------------|------------------------------------|--------------------------------------|
| Jenkins        | `~/.tfvars/jenkins.tfvars`         | `~/.tfvars/minio.backend.hcl`        |
| Dozzle         | `~/.tfvars/dozzle.tfvars`          | `~/.tfvars/minio.backend.hcl`        |
| Node Exporter  | `~/.tfvars/node_exporter.tfvars`   | `~/.tfvars/minio.backend.hcl`        |
| Prometheus     | `~/.tfvars/prometheus.tfvars`      | `~/.tfvars/minio.backend.hcl`        |
| Grafana        | `~/.tfvars/grafana.tfvars`         | `~/.tfvars/minio.backend.hcl`        |

New stacks should add their TFVARS filename to this table (and follow the same naming scheme) so pipeline defaults stay obvious.

### Pipeline entrypoints

Each stack ships with both a bash helper (for local or ad-hoc execution) and a Jenkins job (wired via `terraform/module/jenkins/config`). Use whichever medium matches your access level; both paths source the same helper scripts and tfvars defaults.

| Stack / Stage        | Bash pipeline command                   | Jenkins job name |
|----------------------|-----------------------------------------|------------------|
| Jenkins – Controller | `./pipeline/jenkins/controller.sh`      | `jenkins/controller` |
| Jenkins – Agents     | `./pipeline/jenkins/agent.sh`           | `jenkins/agent` |
| Jenkins – Config     | `./pipeline/jenkins/config.sh`          | `jenkins/config` |
| Dozzle               | `./pipeline/dozzle/deploy.sh`           | `dozzle` |
| Node Exporter        | `./pipeline/node_exporter/deploy.sh`    | `node_exporter` |
| Prometheus – App     | `./pipeline/prometheus/app.sh`          | `prometheus/app` |
| Prometheus – Config  | `./pipeline/prometheus/config.sh`       | `prometheus/config` |
| Grafana – App        | `./pipeline/grafana/app.sh`             | `grafana/app` |
| Grafana – Config     | `./pipeline/grafana/config.sh`          | `grafana/config` |
| Graphite             | `./pipeline/graphite/deploy.sh`         | `graphite` |

## Getting Started

1. Install the baseline tooling: Terraform, Docker, and a shell with `bash` available.
2. Clone this repository and review `AGENTS.md` for machine-specific secrets locations.
3. Follow the environment-specific bootstrap guide in the [wiki](https://github.com/NoDadYouShutUp/homelab/wiki) to wire credentials, backend state, and pipelines.

Once the prerequisites are in place, use the wiki’s runbooks for day-to-day operations (planning/applying Terraform, rotating secrets, updating services, etc.).

## Documentation

The README stays high-level by design. For architecture diagrams, module deep dives, operational runbooks, and troubleshooting tips, head directly to the [project wiki](https://github.com/NoDadYouShutUp/homelab/wiki). It is the authoritative source of truth for everything beyond this overview.
