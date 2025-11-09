# AGENTS

## Secrets & variable locations
- Jenkins agent/controller secrets, CASC fragments, and SSH materials live under `~/.jenkins`. The Jenkins Terraform stages (`terraform/swarm/jenkins/**`) and their pipelines read from this directory, so keep credentials and token files synced before running controller/agent/config deployments.
- Terraform inputs live under `~/.tfvars`. Each Swarm stack defaults to `~/.tfvars/<service>.tfvars` (Dozzle, Grafana, Graphite, Node Exporter, Prometheus) unless the pipeline overrides `DEFAULT_TFVARS_FILE`. Jenkins uses a subfolder with stage-specific files (`~/.tfvars/jenkins/controller.tfvars`, `agent.tfvars`, `config.tfvars`). Legacy non-Swarm stacks (ArgoCD, Proxmox, Talos, etc.) follow the same naming scheme when re-enabled.
- All Swarm stacks use the MinIO backend declared in `~/.tfvars/minio.backend.hcl`. Pipelines pass this file to `terraform init -backend-config` automatically, but you can override it with `--backend`.
- When introducing a new service or stage, create the matching tfvars/backend files under `~/.tfvars`, record them in the planning document, and wire the defaults into the bash pipeline so teammates know which inputs are required.

## Application taxonomy & pipeline expectations
- **App + config** – services that deploy infrastructure and then push additional configuration once the app is reachable (Jenkins controller/agents + config, Grafana app + provider-driven dashboards). These require multiple Terraform surfaces (usually `module/<service>/app` + `module/<service>/config`) and at least two pipelines (`pipeline/<service>/app.*`, `pipeline/<service>/config.*`). Jenkins is the special case with three stages (controller, agent, config) because agents depend on controller outputs.
- **App w/ inline config** – services where configuration is rendered as part of the same Terraform module (Prometheus uses tfvars data to produce the scrape/rules YAML). Pipelines still target the `app` stage but there is no second apply.
- **App only** – single-shot services that embed all behavior in one module (Dozzle, Node Exporter, Graphite). They ship a single pipeline/jenkins pair named `deploy`.
- **Config only (future)** – reserved for stacks that only change configuration for an existing app (for example, an Argo CD workload update). Keep this documented so future contributors add the missing automation layers.
- **Pattern reuse rule** – start from the closest implementation before diverging. Clone Jenkins if you need multi-stage Swarm + Jenkins provider work, Grafana for dual-provider app+config flows, Prometheus for inline-config services, and Dozzle/Graphite for single-stage Swarm apps. Document any deviation inside the planning doc.

## Major feature workflow (all services)
1. **Scope & triggers** – Before touching code, confirm the taxonomy, list the directories you expect to touch (`terraform/module/<service>`, `terraform/swarm/<service>` or `terraform/swarm/<service>/<stage>`, `pipeline/<service>`, relevant `docker/<service>` assets, Jenkins job definitions), and note the tfvars/backend files under `~/.tfvars` that will feed the change.
2. **Create a multi-stage plan document** – Store it at `docs/planning/<service>-plan.md`. Capture the goal/constraints plus numbered Stage sections (Stage 0 – Preparation, Stage 1 – Implementation, etc.) with checkbox tasks (`- [ ]`) spelling out Terraform, pipeline, Jenkins, and documentation work. Call out which prior implementation you are cloning.
3. **Execute stage-by-stage** – Follow the plan order, updating checkboxes as tasks/stages finish. If scope drifts, append a note to the plan before continuing so the history stays accurate.
4. **Validation & wrap-up** – Record which bash/Jenkins pipelines ran, their outcomes, and any pending Terraform applies in the final stage of the plan. Link the new automation (pipelines, Terraform dirs, docs) from that plan so future operators can trace provenance.

The planning document’s checklist remains the readiness gate for Swarm work—finish it before merging.

## Repository surfaces per Swarm service
- **Modules (`terraform/module/<service>`)** – contain the actual Docker resources. Multi-stage services split into `module/<service>/app` and `module/<service>/config` (Grafana) or further granularity (`module/jenkins/{controller,agent}` plus `module/jenkins/config`). Modules hold all static defaults (image digests, labels, networks, health checks) expressed via locals so tfvars stay minimal.
- **Stack entrypoints (`terraform/swarm/<service>`)** – wire Terraform backends, providers, and module invocations. Single-state services (Dozzle, Grafana, Prometheus, Graphite, Node Exporter) live directly under `terraform/swarm/<service>`. Jenkins keeps separate Terraform states per stage at `terraform/swarm/jenkins/{controller,agent,config}` so controller outputs can feed agents.
- **Pipelines (`pipeline/<service>/<stage>.sh`)** – bash entrypoints that set `SERVICE_NAME`, `STAGE_NAME`, and any overrides (for example, `PLAN_ARGS_EXTRA` to `-target` a module or custom `TERRAFORM_DIR`) before sourcing `pipeline/script/swarm_pipeline.sh`. One directory per service keeps app/config/deploy scripts co-located.
- **Jenkins wrappers (`pipeline/<service>/<stage>.jenkins`)** – declarative pipelines that parameterize and call the matching bash script through `runShellPipeline`. Every bash script must have a Jenkins counterpart so CI/CD and local workflows stay in sync.
- **Jenkins job registry (`terraform/module/jenkins/config`)** – the Terraform module that creates Jenkins folders/jobs. Add new services to `local.single_stage_jobs` or `local.multi_stage_services` so jobs are provisioned as soon as the stack merges.
- **Pipeline helpers (`pipeline/script/`)** – shared tooling (`env_check.sh`, `resolve_inputs.sh`, `swarm_pipeline.sh`, `terraform_exec.sh`, `terraform_output_filter.py`) that every stage sources. Keep new helpers here so all services inherit them automatically.
- **Planning docs (`docs/planning/<service>-plan.md`)** – capture scope, reference implementations, validation notes, and outstanding work. They are the source of truth for stage readiness.

## TFVARS, provider_config, and backend contract
- The helper `pipeline/script/resolve_inputs.sh` looks for tfvars/backends in order: CLI flags (`--tfvars`, `--backend`), script overrides (`DEFAULT_TFVARS_FILE`, `DEFAULT_BACKEND_FILE`), then `~/.tfvars/<basename>.tfvars`. Always document the intended filenames and keep them under `~/.tfvars`.
- Every Swarm stack expects a `provider_config` map with at least the Docker host definition (`docker.host` + `docker.ssh_opts`). Add nested provider blocks only when necessary (for example, `provider_config.grafana` for Grafana auth, `provider_config.jenkins` for Jenkins username/password/API token). Keep secrets in tfvars, never in the repo.
- Configuration-heavy services keep their structured inputs in tfvars as well (`casc_config`, `grafana_config_inputs`, `prometheus_config`, Jenkins mounts/env maps). Modules render these maps into YAML/JSON or Docker configs internally so the repo only carries module logic.
- **tfvars hygiene** – Only promote values to tfvars when they are secrets, environment-specific coordinates, or explicitly called out in the plan. Prefer Terraform locals/constants for static behavior to avoid chasing dozens of inputs.
- All Swarm stacks share the MinIO backend (`~/.tfvars/minio.backend.hcl`). Unless a plan explicitly calls for something else, leave the backend key naming consistent (`<service>.tfstate`, `jenkins-<stage>.tfstate`) and let the pipeline pass the backend file automatically.

## Docker Swarm module conventions
- Keep resources prefixed with the service name (`grafana`, `prometheus`, `jenkins-controller`, etc.) and always set `com.docker.stack.namespace` + `com.docker.service` labels so Swarm dashboards stay coherent.
- Encode all static defaults directly in the module via locals: container images/digests, environment defaults, health checks, published ports, placement constraints, and external network attachments (`module/grafana/app` shows the Prometheus network attach pattern).
- Split multi-phase services into explicit modules: `module/grafana/{app,config}`, `module/jenkins/{controller,agent}` + `module/jenkins/config`. Single-phase services keep a single `main.tf`.
- When an app consumes YAML or JSON config (Prometheus scrape config, Grafana dashboards/datasources, Jenkins CASC), accept structured maps in tfvars and render them inside the module with `yamlencode`/`jsonencode` + `docker_config` resources.
- Reuse support modules such as `module/healthcheck` instead of re-implementing polling logic whenever an HTTP health probe is needed outside the container.

## Pipeline implementation details
- Each bash entrypoint under `pipeline/<service>/` defines `SERVICE_NAME`, `STAGE_NAME`, optional overrides (`ENTRYPOINT_RELATIVE`, `TERRAFORM_DIR`, `DEFAULT_TFVARS_FILE`, `PLAN_ARGS_EXTRA`, `APPLY_ARGS_EXTRA`) and then sources `pipeline/script/swarm_pipeline.sh`. Arguments passed to the bash script are forwarded through `PIPELINE_ARGS`.
- `swarm_pipeline.sh` handles `--tfvars`/`--backend` flags, runs the shared helpers (`env_check.sh`, `resolve_inputs.sh`, `terraform_exec.sh`), and performs `terraform init`, `plan`, and `apply`. Output filtering runs through `pipeline/script/terraform_output_filter.py` when Python is available.
- Use `PLAN_ARGS_EXTRA` / `APPLY_ARGS_EXTRA` to scope a stage to part of the stack (`pipeline/grafana/app.sh` targets `module.grafana_app`, config stage targets `module.grafana_config`). Set `TERRAFORM_DIR` when a stage uses its own state directory (all Jenkins stages do this).
- Implement `pipeline_pre_terraform()` inside a stage script when you must prepare data before init/plan. Example: `pipeline/jenkins/agent.sh` initializes the controller backend and exports `TF_VAR_controller_service_id` / `TF_VAR_controller_image` before sourcing `swarm_pipeline.sh`.
- Every bash script has a `.jenkins` sibling that uses the shared `runShellPipeline` helper to execute the shell script inside Jenkins. Always keep the Jenkins script name in sync with the bash entrypoint path exposed through Terraform (`terraform/module/jenkins/config`).

## Jenkins job automation
- `terraform/module/jenkins/config/main.tf` provisions folders/jobs using the `taiidani/jenkins` provider. Update the locals there whenever a pipeline changes:
  - Add app-only services (Dozzle, Node Exporter, Graphite, Prometheus deploy) to `local.single_stage_jobs`.
  - Add multi-stage services to `local.multi_stage_services`, listing each stage name + script path so Terraform creates the folder and jobs (Grafana currently uses app/config).
  - Keep Jenkins controller/agent/config jobs listed in `local.jenkins_jobs`; treat them as the canonical reference for multi-stage patterns.
- New jobs must point at the `pipeline/<service>/<stage>.jenkins` script path and include a short description explaining what the stage deploys. The Jenkins provider template will take care of the rest.

## Docker Swarm service workflow
- **Stage 0 – Baseline**: Document the reference implementation you are cloning (Jenkins, Grafana, Prometheus, Dozzle/Graphite) in the plan. Capture all touchpoints you will need: `terraform/module/<service>` scaffolding, `terraform/swarm/<service>` or per-stage subdirectories, pipeline entrypoints, Jenkins jobs, tfvars/backends, and any supporting Docker assets. Explicitly note the tfvars filenames and backend key you expect to use.
- **Stage 1 – Terraform scaffolding**: Build or extend `terraform/module/<service>` (and `app`/`config` submodules when needed) plus the matching `terraform/swarm/<service>` stack. Keep provider wiring aligned with `provider_config` inputs and reference the `~/.tfvars/minio.backend.hcl` backend. Export outputs that downstream stages might need (for example, Jenkins controller service ID/image).
- **Stage 2 – Pipelines**: Create `pipeline/<service>/<stage>.sh` and `.jenkins` files. Set `DEFAULT_TFVARS_BASENAME`/`DEFAULT_TFVARS_FILE`, `STAGE_NAME`, and `PLAN/APPLY` targets so the shared `swarm_pipeline.sh` helper can run unattended. Document any stage-specific environment requirements (`pipeline_pre_terraform`) inside both the script comments and the planning doc.
- **Stage 3 – Jenkins integration & configs**: For app + config or inline config services, ensure both stages are registered in `terraform/module/jenkins/config` and that tfvars files contain the secrets/config needed. For app-only services, add the single job entry and double-check Jenkins credentials in `~/.jenkins` still match the provider block.
- **Stage 4 – Validation & docs**: Run the bash pipelines (and Jenkins jobs when possible), record the command/output location plus backend state in the planning doc, and update wiki/runbooks with any new operational steps. Leave a note if applies were deferred or require credentials beyond the repo.

## Resource links
- **Terraform providers**
  - [`kreuzwerker/docker`](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs) – used by every Swarm stack under `terraform/swarm/*` and the corresponding modules.
  - [`grafana/grafana`](https://registry.terraform.io/providers/grafana/grafana/latest/docs) – powers `terraform/module/grafana/config` for dashboards, folders, and datasources.
  - [`taiidani/jenkins`](https://registry.terraform.io/providers/taiidani/jenkins/latest/docs) – manages `terraform/module/jenkins/config` (folders/jobs) and Jenkins-aware stacks.
- **Container images**
  - [`amir20/dozzle`](https://github.com/amir20/dozzle) – referenced in `terraform/module/dozzle`.
  - [`prom/node-exporter`](https://hub.docker.com/r/prom/node-exporter) – referenced in `terraform/module/node_exporter`.
  - [`prom/prometheus`](https://hub.docker.com/r/prom/prometheus) – referenced in `terraform/module/prometheus`.
  - [`grafana/grafana`](https://hub.docker.com/r/grafana/grafana) – referenced in `terraform/module/grafana/app`.
  - [`graphiteapp/graphite-statsd`](https://hub.docker.com/r/graphiteapp/graphite-statsd) – referenced in `terraform/module/graphite`.
  - [`minio/minio`](https://min.io/docs/minio/container/index.html) – defined via `docker/minio/docker-compose.yaml` for the Terraform backend.
  - [`ghcr.io/nodadyoushutup/jenkins-controller`](docker/jenkins/controller) – custom controller image built from `docker/jenkins/controller/`.
  - [`ghcr.io/nodadyoushutup/jenkins-agent`](docker/jenkins/agent) – custom agent image built from `docker/jenkins/agent/`.

> Finish the staged plan in `docs/planning` before merging—its checklist is the single source of truth for Swarm readiness.
