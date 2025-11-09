# AGENTS

## Secrets & variable locations
- Jenkins agent secrets configuration directory: `~/.jenkins`
- Terraform variable files live under `~/.tfvars`; current files include `argocd.tfvars`, `docker_swarm.tfvars`, `dozzle.tfvars`, `jenkins.tfvars`, `minio.backend.hcl`, `node_exporter.tfvars`, `prometheus.tfvars`, `proxmox.tfvars`, and `talos.tfvars`. Reference these when wiring provider blocks or pipelines.
- When adding a new Terraform service, create a dedicated tfvars file under `~/.tfvars` if one doesn’t already exist, mirroring patterns from the closest existing tfvars to keep inputs consistent.

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

## Docker Swarm reference layout
- **Directory pairing**: Every Swarm service owns `terraform/module/<service>` (real resources) and `terraform/swarm/<service>` (backend + provider wiring + module calls). For multi-phase stacks (Grafana, Jenkins) keep `module/<service>/app` and `module/<service>/config` side by side and invoke them both from the service entrypoint.
- **Module contents**: Modules hold the opinionated defaults—image digests, network names, health checks, Swarm constraints, labels, ports—expressed directly in Terraform using locals where helpful. Only add variables for data that must vary per environment (passwords, hostnames, structured config blobs) so contributors don’t have to chase 20 inputs through tfvars.
- **Naming & labels**: Follow the existing pattern of `<service>`-prefixed Docker networks, volumes, secrets, and service names, and always set `com.docker.stack.namespace` and `com.docker.service` labels so Swarm dashboards stay consistent.
- **Stack inputs**: `terraform/swarm/<service>/variables.tf` should expose the smallest contract needed by the modules. The canonical tfvars lives at `~/.tfvars/<service>.tfvars` and always contains `provider_config.docker.host` plus `ssh_opts`; add nested maps (for example, `provider_config.grafana`, `provider_config.jenkins`) only when the service genuinely needs an extra provider.
- **tfvars hygiene**: Keep tfvars for secrets, infrastructure coordinates, or operator-owned config (Grafana datasources, Prometheus scrape targets, Jenkins CASC). Static module behavior belongs in code. When unsure, default to Terraform locals/constants and only promote a value to tfvars if (a) it contains a secret, (b) it changes per environment, or (c) the planning doc explicitly calls it out as site-specific.
- **Backend + pipelines**: All Swarm stacks use the MinIO backend via `~/.tfvars/minio.backend.hcl`. Each service exports both `pipeline/<service>.sh` and `pipeline/<service>.jenkins` built from the existing helpers in `pipeline/script/`. The shell wrapper must define `DEFAULT_TFVARS_BASENAME`, `DEFAULT_TFVARS_FILE`, and `DEFAULT_BACKEND_FILE`, run `terraform init` with backend config, then `plan` + `apply`. Jenkins wrappers simply delegate to the shell script.
- **Jenkins jobs**: Every Swarm service must register a Jenkins job in `terraform/module/jenkins/config` that points at its `pipeline/<service>.jenkins` entry so CI/CD is available as soon as the stack lands. Clone an existing job template (Dozzle/Prometheus) and only adjust the description + script path.

## Docker Swarm service workflow (services under `docker/swarm/<service>` or otherwise targeting Swarm)
- **Stage 0 – Baseline**: Inventory an existing Swarm app (Dozzle/Node Exporter) to clone patterns. Capture touchpoints (Terraform module + stack, pipelines, Jenkins jobs, helper scripts) in the plan and explicitly note which reference implementation you are mirroring before writing new code.
- **Stage 1 – Terraform scaffolding**: Create/extend `terraform/module/<service>` and `terraform/services/<service>` plus ensure provider config maps line up with the appropriate tfvars file (often `~/.tfvars/<service>.tfvars` plus `~/.tfvars/minio.backend.hcl` for backend data).
- When an app + config service must consume YAML config directly (for example, Prometheus, which lacks a Terraform provider for rule files), model that configuration as structured data inside the tfvars file and render it to encoded YAML within Terraform before handing it to the application layer.
- **Stage 2 – Pipelines**: Produce both `pipeline/<service>.sh` and `pipeline/<service>.jenkins` sourced from `pipeline/script/*.sh`. Document defaults like `DEFAULT_TFVARS_BASENAME` and network names inside the plan.
- **Stage 3 – Jenkins integration & configs**: If the service is **app + config**, split the plan into app deployment and config application (for example, Jenkins controller, Jenkins agent, configuration job). For **app only** or inline config services (Dozzle, Prometheus), this stage just wires Jenkins jobs and tfvars secrets.
- **Stage 4 – Validation & docs**: Run the bash pipeline (optionally Jenkins) and capture results in the plan. Update `docs/wiki` or relevant READMEs with runbooks and note any deferred follow-ups.

## Resource links
- **Terraform providers**
  - [`kreuzwerker/docker`](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs) – used by every Swarm stack under `terraform/swarm/*` and the corresponding modules.
  - [`taiidani/jenkins`](https://registry.terraform.io/providers/taiidani/jenkins/latest/docs) – powers `terraform/module/jenkins/config` (folder/job management) and any stack that provisions Jenkins resources.
- **Container images**
  - [`amir20/dozzle`](https://github.com/amir20/dozzle) – referenced in `terraform/module/dozzle`.
  - [`prom/node-exporter`](https://hub.docker.com/r/prom/node-exporter) – referenced in `terraform/module/node_exporter`.
  - [`prom/prometheus`](https://hub.docker.com/r/prom/prometheus) – referenced in `terraform/module/prometheus`.
  - [`minio/minio`](https://min.io/docs/minio/container/index.html) – defined via `docker/minio/docker-compose.yaml` for the Terraform backend.
  - [`ghcr.io/nodadyoushutup/jenkins-controller`](docker/jenkins/controller) – custom controller image built from `docker/jenkins/controller/`.
  - [`ghcr.io/nodadyoushutup/jenkins-agent`](docker/jenkins/agent) – custom agent image built from `docker/jenkins/agent/`.

> Always finish the Swarm stages before merging: the checklist in the plan document is the single source of truth for readiness.
