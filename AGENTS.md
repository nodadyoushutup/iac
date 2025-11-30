# AGENTS

Use this as a directory to the source-of-truth docs agents need.

- Machine inventory (hosts, IPs, OS/arch, Docker versions, access/NFS notes): `docs/wiki/Machines.md`.
- Secrets, tfvars/backends, kube configs, env files: `docs/wiki/Secrets.md`.
- SSH CA workflow (host/user certs, trust install, cleanup, container usage): `docs/wiki/SSH-CA.md`.
- Docker Swarm workflow (taxonomy, planning stages, pipelines/Jenkins, tfvars/backends, purge scripts, resource links): `docs/wiki/Docker-Swarm.md`.
- Planning docs for active changes: `docs/planning/<service>-plan.md` (complete before merging).
- Repo path is `~/code/homelab` everywhere via NFS from `truenas.internal` (see Machines for export details).
- Compose-only stack (MinIO backend + Renovate) runs on `medusa.internal` under `docker/state/`; images must support `linux/aarch64`.
