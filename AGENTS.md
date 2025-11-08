# AGENTS

## Secrets & variable locations
- Jenkins agent secrets configuration directory: `~/.jenkins`
- Terraform variable files live under `~/.tfvars`; current files include `argocd.tfvars`, `docker_swarm.tfvars`, `dozzle.tfvars`, `jenkins.tfvars`, `minio.backend.hcl`, `node_exporter.tfvars`, `prometheus.tfvars`, `proxmox.tfvars`, and `talos.tfvars`. Reference these when wiring provider blocks or pipelines.

## Application taxonomy
- **App + config**: Services that require both infrastructure and follow-up configuration stages (for example, Jenkins controller + agent plus a config phase). Expect multi-stage pipelines and separate Terraform surfaces for app pieces and config pushes.
- **App only**: Services deployed once with configuration embedded in the same Terraform stack (for example, Dozzle). Pipelines usually just wrap `terraform/services/<app>` without a follow-up config apply.
- **App w/ inline config**: Services like Prometheus where the configuration is injected directly into the app module/stack; treat them like “app only” from a pipeline standpoint but keep config inputs in the same plan.
- **Config only (future)**: Reserved for upcoming scenarios where existing apps (for example, Argo CD workloads) get new configuration pipelines without touching their base infrastructure. Keep this category documented so contributors know to add the missing workflows later.
- **Pattern reuse rule**: Start from the closest existing implementation (Jenkins for app+config, Dozzle for app-only Swarm, Prometheus for inline config) and clone its structure/files before changing functionality. Consistency across Terraform modules, pipelines, and docs takes priority unless a plan explicitly records why a deviation is needed.

## Major feature workflow (all services)
1. **Scope & triggers**: Before touching code, confirm the service type (see taxonomy above), directories involved (`terraform/services`, `docker`, `pipeline`, etc.), and any required tfvars/backend files under `~/.tfvars`.
2. **Create a multi-stage plan document**:
   - Place the plan in `docs/planning/<service>-plan.md`.
   - Include context (Goals & Constraints) and numbered “Stage” sections (Stage 0 – Preparation, Stage 1 – Implementation, etc.).
   - Each stage must contain checkbox tasks (`- [ ]`) describing the concrete work to perform.
3. **Execute stage-by-stage**:
   - Work through the plan in order; after each task or stage completes, update the checkboxes in the plan so progress is transparent.
   - If scope changes, append a note to the plan before continuing so history stays accurate.
4. **Validation & wrap-up**:
   - Record validation steps/outcomes in the final stage of the plan (tests run, pipelines triggered, Terraform applies performed or deferred).
   - Link or reference any new automation (pipelines, Terraform services, docs) in the same plan so future operators can trace provenance.

## Docker Swarm service workflow (services under `docker/swarm/<service>` or otherwise targeting Swarm)
- **Stage 0 – Baseline**: Inventory an existing Swarm app (Dozzle/Node Exporter) to clone patterns. Capture touchpoints (Terraform module + stack, pipelines, Jenkins jobs, helper scripts) in the plan and explicitly note which reference implementation you are mirroring before writing new code.
- **Stage 1 – Terraform scaffolding**: Create/extend `terraform/module/<service>` and `terraform/services/<service>` plus ensure provider config maps line up with the appropriate tfvars file (often `~/.tfvars/<service>.tfvars` plus `~/.tfvars/minio.backend.hcl` for backend data).
- **Stage 2 – Pipelines**: Produce both `pipeline/<service>.sh` and `pipeline/<service>.jenkins` sourced from `pipeline/script/*.sh`. Document defaults like `DEFAULT_TFVARS_BASENAME` and network names inside the plan.
- **Stage 3 – Jenkins integration & configs**: If the service is **app + config**, split the plan into app deployment and config application (for example, Jenkins controller, Jenkins agent, configuration job). For **app only** or inline config services (Dozzle, Prometheus), this stage just wires Jenkins jobs and tfvars secrets.
- **Stage 4 – Validation & docs**: Run the bash pipeline (optionally Jenkins) and capture results in the plan. Update `docs/wiki` or relevant READMEs with runbooks and note any deferred follow-ups.

> Always finish the Swarm stages before merging: the checklist in the plan document is the single source of truth for readiness.
