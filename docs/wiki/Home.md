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

- On this page
  - [What lives here](#what-lives-here)
  - [Getting started](#getting-started)
  - [Table of contents](#table-of-contents)
  - [Roadmap toward homelab](#roadmap-toward-homelab)
  - [Need something?](#need-something)

- Wiki pages
  - [[Machines]]
    - [[Machines#machine-map|Machine map]]
    - [[Machines#agent-guidance-see-agentsmd|Agent guidance (see AGENTS.md)]]
    - [[Machines#operational-notes|Operational notes]]
  - [[Secrets]]
    - [[Secrets#locations|Locations]]
    - [[Secrets#handling-guidance|Handling guidance]]
  - [[SSH-CA|SSH CA (Machine Onboarding)]]
    - [[SSH-CA#ca-materials-one-time|CA materials (one-time)]]
    - [[SSH-CA#onboard-a-machine-to-the-ca|Onboard a machine to the CA]]
    - [[SSH-CA#notes|Notes]]
  - [[SSH-CA-Cleanup|SSH CA Cleanup]]
    - [[SSH-CA-Cleanup#expected-state|Expected state]]
    - [[SSH-CA-Cleanup#steps-verify-correct-if-needed|Steps (verify → correct if needed)]]
  - [[Docker-Swarm|Docker Swarm]]
    - [[Docker-Swarm#control-endpoints-state|Control endpoints & state]]
    - [[Docker-Swarm#application-taxonomy-provider-expectations|Application taxonomy & provider expectations]]
    - [[Docker-Swarm#major-feature-workflow|Major feature workflow]]
    - [[Docker-Swarm#repository-surfaces-per-swarm-service|Repository surfaces per Swarm service]]
    - [[Docker-Swarm#tfvars-providerconfig-and-backend-contract|TFVARS, provider_config, and backend contract]]
    - [[Docker-Swarm#docker-swarm-module-conventions|Docker Swarm module conventions]]
    - [[Docker-Swarm#pipeline-implementation-details|Pipeline implementation details]]
    - [[Docker-Swarm#jenkins-job-automation|Jenkins job automation]]
    - [[Docker-Swarm#docker-swarm-service-workflow|Docker Swarm service workflow]]
    - [[Docker-Swarm#resource-links|Resource links]]
  - [[Swarm-Node-Onboarding|Swarm Node Onboarding]]
    - [[Swarm-Node-Onboarding#prerequisites|Prerequisites]]
    - [[Swarm-Node-Onboarding#manual-join-procedure|Manual join procedure]]
  - [[Docker-Node-Labels|Docker Node Labels]]
    - [[Docker-Node-Labels#docker-swarm-nodes-labels-and-constraints-quick-guide|Docker Swarm: nodes, labels, and constraints (quick guide)]]
    - [[Docker-Node-Labels#label-strategy-overview|Label strategy overview]]
    - [[Docker-Node-Labels#known-labels-in-this-swarm|Known labels in this swarm]]
    - [[Docker-Node-Labels#rolecicd|`role=cicd`]]
    - [[Docker-Node-Labels#rolemonitoring|`role=monitoring`]]
    - [[Docker-Node-Labels#roledatabase|`role=database`]]
    - [[Docker-Node-Labels#roleedge|`role=edge`]]
    - [[Docker-Node-Labels#current-homelab-node-map|Current homelab node map]]
    - [[Docker-Node-Labels#fast-label-commands-for-this-cluster|Fast label commands for this cluster]]
    - [[Docker-Node-Labels#ensure-existing-labels-stay-present|Ensure existing labels stay present]]
    - [[Docker-Node-Labels#promote-additional-database-nodes-pick-workers-with-ssdnvme|Promote additional database nodes (pick workers with SSD/NVMe)]]
    - [[Docker-Node-Labels#quick-removals-when-shifting-roles|Quick removals when shifting roles]]
    - [[Docker-Node-Labels#optional-label-the-controller-if-you-need-manager-only-workloads|Optional: label the controller if you need manager-only workloads]]
    - [[Docker-Node-Labels#1-see-your-docker-nodes|1) See your Docker nodes]]
    - [[Docker-Node-Labels#list-all-nodes-in-the-swarm|List all nodes in the Swarm]]
    - [[Docker-Node-Labels#optional-quick-view-with-hostname-availability-labels|Quick view with hostname + availability + labels]]
    - [[Docker-Node-Labels#2-see-what-labels-a-node-has|2) See what labels a node has]]
    - [[Docker-Node-Labels#show-labels-for-one-node-replace-node-with-id-or-hostname-from-docker-node-ls|Show labels for one node]]
    - [[Docker-Node-Labels#pretty-print-labels-requires-jq|Pretty-print labels (requires jq)]]
    - [[Docker-Node-Labels#full-human-readable-inspect-labels-included-near-the-top|Full human-readable inspect]]
    - [[Docker-Node-Labels#3-add-or-change-a-label-eg-rolecicd|3) Add (or change) a label (e.g., role=cicd)]]
    - [[Docker-Node-Labels#addupdate-label-rolecicd-on-a-node|Add/update label role=cicd on a node]]
    - [[Docker-Node-Labels#verify|Verify]]
    - [[Docker-Node-Labels#4-use-the-label-in-placement-constraints|4) Use the label in placement constraints]]
    - [[Docker-Node-Labels#a-with-docker-service-create|A) With docker service create]]
    - [[Docker-Node-Labels#b-in-a-composestack-file-docker-stack-deploy|B) In a Compose/Stack file (docker stack deploy)]]
    - [[Docker-Node-Labels#docker-composeyml|docker-compose.yml]]
    - [[Docker-Node-Labels#c-in-code-array-style-eg-pulumiterraformsdks|C) In code (array style), e.g. Pulumi/Terraform/SDKs]]
    - [[Docker-Node-Labels#5-confirm-the-constraint-is-working|5) Confirm the constraint is working]]
    - [[Docker-Node-Labels#check-where-the-task-is-scheduled|Check where the task is scheduled]]
    - [[Docker-Node-Labels#or-for-stacks|Or for stacks]]
  - [[Repo-Structure|Repo Structure]]
    - [[Repo-Structure#conventions|Conventions]]
  - [[Jenkins]]
    - [[Jenkins#images|Images]]
    - [[Jenkins#deployment|Deployment]]
    - [[Jenkins#operations|Operations]]
  - [[MinIO]]
    - [[MinIO#why-docker-compose-instead-of-terraform|Why Docker Compose instead of Terraform]]
    - [[MinIO#file-layout|File layout]]
    - [[MinIO#bootstrapping-minio|Bootstrapping MinIO]]
    - [[MinIO#operations|Operations]]
    - [[MinIO#environment-variable-reference|Environment variable reference]]
  - [[Nginx-Proxy-Manager|Nginx Proxy Manager]]
    - [[Nginx-Proxy-Manager#architecture|Architecture]]
    - [[Nginx-Proxy-Manager#terraform-surfaces|Terraform surfaces]]
    - [[Nginx-Proxy-Manager#tfvars-secrets|Tfvars & secrets]]
    - [[Nginx-Proxy-Manager#pipelines-jenkins-jobs|Pipelines & Jenkins jobs]]
    - [[Nginx-Proxy-Manager#operations-runbook|Operations & runbook]]
    - [[Nginx-Proxy-Manager#validation-matrix|Validation matrix]]
    - [[Nginx-Proxy-Manager#reference-links|Reference links]]
  - [[Prometheus]]
    - [[Prometheus#prerequisites|Prerequisites]]
    - [[Prometheus#pipelines|Pipelines]]
    - [[Prometheus#bash-deployment-pipelineprometheusappsh|Bash deployment (pipeline/prometheus/app.sh)]]
    - [[Prometheus#jenkins-deployment-prometheus|Jenkins deployment (prometheus)]]
    - [[Prometheus#validation-checklist|Validation checklist]]
    - [[Prometheus#editing-scrape-configs|Editing scrape configs]]
    - [[Prometheus#changing-ports-or-persistence|Changing ports or persistence]]
    - [[Prometheus#follow-up-ideas|Follow-up ideas]]
  - [[Grafana]]
    - [[Grafana#overview|Overview]]
    - [[Grafana#prerequisites|Prerequisites]]
    - [[Grafana#tfvars-structure|TFVARS structure]]
    - [[Grafana#bash-pipelines|Bash pipelines]]
    - [[Grafana#app-stage-pipelinegrafanaappsh|App stage (pipeline/grafana/app.sh)]]
    - [[Grafana#config-stage-pipelinegrafanaconfigsh|Config stage (pipeline/grafana/config.sh)]]
    - [[Grafana#jenkins-pipelines|Jenkins pipelines]]
    - [[Grafana#updating-dashboards-or-data-sources|Updating dashboards or data sources]]
    - [[Grafana#node-exporter-dashboard-folder|Node Exporter dashboard folder]]
    - [[Grafana#truenas-dashboard-folder|TrueNAS dashboard folder]]
    - [[Grafana#graphite-inventory-helper|Graphite inventory helper]]
    - [[Grafana#validation-checklist|Validation checklist]]
    - [[Grafana#rollback-destroy|Rollback / destroy]]
    - [[Grafana#troubleshooting|Troubleshooting]]
    - [[Grafana#references|References]]
  - [[Graphite]]
    - [[Graphite#prerequisites|Prerequisites]]
    - [[Graphite#deploy-via-bash-pipeline|Deploy via bash pipeline]]
    - [[Graphite#deploy-via-jenkins|Deploy via Jenkins]]
    - [[Graphite#managing-configuration|Managing configuration]]
    - [[Graphite#validation-checklist|Validation checklist]]
    - [[Graphite#troubleshooting|Troubleshooting]]
  - [[Node-Exporter|Node Exporter]]
    - [[Node-Exporter#prerequisites|Prerequisites]]
    - [[Node-Exporter#deploy-via-bash-pipeline|Deploy via bash pipeline]]
    - [[Node-Exporter#validation-checklist|Validation checklist]]
    - [[Node-Exporter#deploy-via-jenkins|Deploy via Jenkins]]
    - [[Node-Exporter#prometheus-scraping|Prometheus scraping]]
    - [[Node-Exporter#changing-the-published-port|Changing the published port]]
    - [[Node-Exporter#follow-up-ideas|Follow-up ideas]]

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
