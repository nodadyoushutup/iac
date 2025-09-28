# Jenkins Infrastructure

## Overview
This repository provisions a Jenkins controller and a fleet of inbound agents on a Docker Swarm host. Terraform drives the `kreuzwerker/docker` provider over SSH, renders Jenkins Configuration as Code (JCasC) into a Docker config, and waits for the controller to come online before starting the agents defined in that configuration. Custom controller and agent container images are published to GHCR with the tooling required for typical infrastructure workloads (Terraform, Packer, Ansible, MinIO client, etc.).

## Repository Layout
- `terraform/` root module plus submodules for the controller and agent Docker services.
- `docker/` Dockerfiles, compose file, plugin list, and a JCasC example for building or testing the images locally.
- `pipeline/` opinionated wrapper that runs `terraform init`, `plan`, and `apply` with project defaults.
- `purge.sh` destructive helper that removes Docker services, configs, images, and volumes from the target host.

## Prerequisites
- Terraform 1.5+ with access to the internet to download providers.
- A Docker Swarm manager node reachable from your workstation (typically via `ssh://user@host`) and a user with permission to create services, configs, and volumes.
- An S3 or S3-compatible object store (for example MinIO) to host the Terraform state backend.
- A Jenkins Configuration as Code YAML document describing the controller, credentials, and agent definitions.
- Local tools used by helper scripts: `bash`, `curl`, and `realpath`.

## Getting Started
1. **Prepare the backend configuration** – Create a file such as `backend.hcl` that points to your state bucket:
   ```hcl
   bucket                      = "terraform"
   key                         = "jenkins/terraform.tfstate"
   endpoint                    = "http://minio.example.com:9000"
   access_key                  = "<access-key>"
   secret_key                  = "<secret-key>"
   skip_credentials_validation = true
   skip_region_validation      = true
   ```

2. **Create a variable file** – The root module expects two complex variables: `provider_config` and `casc_config`. An example `jenkins.tfvars` might look like:
   ```hcl
   provider_config = {
     docker = {
       host     = "ssh://ubuntu@192.168.1.50"
       ssh_opts = ["-i", "~/.ssh/id_ed25519", "-o", "StrictHostKeyChecking=no"]
     }
     jenkins = {
       server_url = "http://192.168.1.50:8080"
     }
   }

   casc_config = yamldecode(file("config.yaml"))
   ```
   Use `docker/config.yaml.example` as a starting point for your JCasC file. Each entry in `jenkins.nodes` creates a matching Docker service for an inbound agent.

3. **Run Terraform** – From the repository root:
   ```bash
   cd terraform
   terraform init -backend-config=../backend.hcl
   terraform plan -var-file=../jenkins.tfvars
   terraform apply -var-file=../jenkins.tfvars
   ```
   The controller module publishes a Docker config that contains your JCasC payload, mounts shared directories from the host (`~/.jenkins`, `~/.ssh`, `~/.kube`, `~/.tfvars`), and exposes ports 8080 and 50000. A `null_resource` health check follows the `/whoAmI` endpoint until Jenkins reports as authenticated before agents are created.

4. **Inspect outputs and verify** – `terraform output` shows the controller service ID and renders the effective JCasC YAML for troubleshooting.

## Helper Scripts
- `pipeline/pipeline.sh` looks for `~/.tfvars/minio.backend.hcl` and `~/.tfvars/jenkins.tfvars`, then runs `terraform init/plan/apply` (with `-auto-approve`). Adjust those paths or create symlinks to reuse the script in automation.
- `purge.sh` force-deletes **all** containers, services, configs, images, and volumes on the Docker host while keeping swarm membership and networks. Use only when you need to reset the environment.

## Custom Images and Local Testing
The `docker/controller` and `docker/agent` Dockerfiles extend the upstream Jenkins images with a curated toolchain and are built from the `docker/` directory. The repository relies on the published images `ghcr.io/nodadyoushutup/jenkins-controller` and `ghcr.io/nodadyoushutup/jenkins-agent`, but you can rebuild them locally when experimenting:
```bash
cd docker
docker build -t ghcr.io/nodadyoushutup/jenkins-controller:dev -f controller .
docker build -t ghcr.io/nodadyoushutup/jenkins-agent:dev -f agent .
```
`docker/docker-compose.yml` launches a single-node Jenkins controller using the same images and JCasC content for local validation. Supply `ADMIN_USERNAME`, `ADMIN_PASSWORD`, and point the config volume at your YAML file.

## Operational Notes
- Agents wait for their secrets under `~/.jenkins/<agent>.secret`; the controller ships with an init script (`docker/export-agent-secret.groovy`) that writes them when the JCasC configuration creates inbound agents.
- Both controller and agent services expect access to `/dev/kvm` and several dot-directories on the host. Ensure those paths exist and contain the credentials or kubeconfigs your jobs require.
- The health check script under `terraform/module/app/controller/healthcheck.sh` can also be reused to verify other endpoints by adjusting the environment variables documented in the file.
