# Machines

This page catalogs the machines that make up the homelab and the default expectations for how Codex interacts with them.

## Machine map

| Hostname | IP address | Role |
| --- | --- | --- |
| nodadyoushutup.internal | 192.168.1.36 | local development / coding |
| medusa.internal | 192.168.1.34 | Docker Compose host (MinIO, Renovate) |
| swarm-cp-0.internal | 192.168.1.22 | Docker Swarm controller (role=controller) |
| swarm-wk-0.internal | 192.168.1.23 | Docker Swarm worker (role=cicd) |
| swarm-wk-1.internal | 192.168.1.24 | Docker Swarm worker (role=database) |
| swarm-wk-2.internal | 192.168.1.25 | Docker Swarm worker (role=monitoring) |
| swarm-wk-3.internal | 192.168.1.28 | Docker Swarm worker (role=edge) |

## Operational notes

1. Every machine assumes a primary `nodadyoushutup` user (uid 1000, gid 1000).
2. `nodadyoushutup.internal` is the development workstation where Codex runs local commands by default.
3. When work must happen on another host, run commands over SSH from the development machine or SSH into the target directly.
4. All machines mount the same NFS share at `~/code/homelab`, so code changes fan out everywhere; paths are consistent across hosts.
5. `medusa.internal` is the single Docker Compose host for MinIO (Terraform state backend) and Renovate; it is intentionally outside the Swarm.
6. Swarm nodes host all Terraform-managed workloads; pipelines target `swarm-cp-0.internal` as the Swarm controller endpoint.
