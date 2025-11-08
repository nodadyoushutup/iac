# NoDad Infrastructure as Code (IaC)

Welcome to the hub for the NoDad infrastructure stack. This repository is
evolving into a unified `iac` project that centralizes automation,
configuration, and documentation for every platform service.

## What lives here

- **Jenkins automation** – Dockerfiles, pipelines, and helper scripts for the
  controller and agent images. See [[Jenkins]] for the full tour.
- **MinIO backend** – A Docker Compose stack that must exist before Terraform
  runs so the rest of the platform can reuse its S3-compatible state store.
  See [[MinIO]] for bootstrap and operations details.
- **Shared docs** – Authoritative notes for operations and design decisions.
  Each service lands in its own page under this wiki.
- **Runbooks & references** – Quick pointers for onboarding, incident response,
  and maintenance as the platform grows.

## Getting started

1. Clone the repo: `git clone https://github.com/nodadyoushutup/jenkins.git`
2. Install Docker and Docker Compose (required for local Jenkins work).
3. Review [[Repo Structure]] to learn where new infrastructure-as-code assets
   belong.
4. Run the provided scripts or pipelines before opening PRs to prove
   reproducibility.

## Roadmap toward `iac`

The Jenkins assets are the first milestone. Upcoming additions will include:

- Terraform modules and environment definitions.
- Shared CI/CD pipelines for infrastructure changes.
- Observability tooling (dashboards, alerts, logging pipelines).
- Documentation and runbooks for every managed service.

Contributions should follow an "infrastructure as product" mindset—every new
component needs automation, documentation, and reproducible workflows.

## Need something?

Open a GitHub issue or drop a note in team chat. This wiki should change often,
so add context as soon as you learn it.
