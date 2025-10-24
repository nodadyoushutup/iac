# Repo Structure

```
/
├── docs/wiki/             # Wiki content synced to GitHub Wiki
├── docker/
│   └── jenkins/           # Dockerfiles, scripts, and compose assets
├── pipeline/              # Jenkins pipeline definitions
├── terraform/             # Terraform modules (coming soon)
├── AGENTS.md              # Jenkins agent catalog
└── renovate.json          # Dependency automation configuration
```

## Conventions

- Place documentation alongside the code it explains. If a new service needs a
  runbook, create `docs/wiki/<Service>.md` and link it from the sidebar.
- Add supporting scripts under a service-specific directory (for example,
  `docker/<service>/`).
- Infrastructure changes must be reproducible locally—include helper scripts
  or instructions before opening a PR.

As the repository transitions to `iac`, keep this file updated so the wiki stays
accurate for new contributors.
