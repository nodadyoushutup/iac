# NoDad Infrastructure as Code (IaC)

Welcome to the home for the NoDad infrastructure stack. This repository is
evolving toward a unified `iac` project that centralizes automation,
configuration, and documentation for all platform services.

## What lives here

- **Jenkins automation** – Dockerfiles, pipelines, and helper scripts that
  build and publish the controller and agent images. See
  [Jenkins Overview](jenkins.md) for details.
- **Shared docs** – Authoritative notes for day-to-day operations and design
  decisions. Each service gets its own page under `docs/`.
- **Runbooks & references** – Quick pointers for onboarding and maintenance as
  the platform grows.

## Getting started

1. Clone the repo: `git clone https://github.com/nodadyoushutup/jenkins.git`
2. Install Docker and Docker Compose (required for local Jenkins work).
3. Review the [Repo Structure](repo-structure.md) to understand where to add new
   infrastructure-as-code assets.

## Roadmap toward `iac`

The Jenkins assets are only the first step. Upcoming additions will include:

- Terraform modules and environment definitions.
- Shared CI/CD pipelines for infrastructure changes.
- Observability tooling (dashboards, alerts, logging pipelines).
- Documentation and runbooks for every managed service.

Contributions should follow an "infrastructure as product" mindset: every new
component needs automation, documentation, and reproducible workflows.

## Need something?

Open an issue in GitHub or drop a note in the team chat. This wiki is meant to
be edited often—add context as soon as you learn it.
