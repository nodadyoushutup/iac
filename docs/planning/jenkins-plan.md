# Jenkins mounts update

Goal: bake the Jenkins controller/agent mounts into Terraform (remove tfvars dependency), align them with the current EAPP NFS shares, and pass SSH CA trust into the containers so jobs can SSH without custom tfvars wiring.

## Stage 0 – Preparation
- [x] Taxonomy: existing multi-stage Jenkins stack (controller/agent/config) using Docker + taiidani/jenkins providers; reuse current Jenkins implementation patterns.
- [x] Provider check: kreuzwerker/docker (3.6.2) + taiidani/jenkins (0.11.0) already in use for this stack.
- [x] Reference surfaces to touch: `terraform/module/jenkins/{controller,agent}`, `terraform/swarm/jenkins/{controller,agent}`, home tfvars under `~/.tfvars/jenkins/*.tfvars`; pipelines stay aligned with existing Jenkins scripts.
- [x] Backend/tfvars existence (verified):
  - [x] `ls ~/.tfvars/minio.backend.hcl`
  - [x] `ls ~/.tfvars/jenkins/controller.tfvars`
  - [x] `ls ~/.tfvars/jenkins/agent.tfvars`
  - [x] `ls ~/.tfvars/jenkins/config.tfvars`
- [x] Planned baked-in mounts (EAPP shares only; skip epool): use NFS mounts for `/home/jenkins/code`, `/home/jenkins/.tfvars`, `/home/jenkins/.kube`, `/home/jenkins/.jenkins` from `192.168.1.100:/mnt/eapp/home/{code,.tfvars,.kube,.jenkins}` with `nfsvers=4.2,proto=tcp,rsize=1048576,wsize=1048576,hard,intr,noatime,actimeo=1,nconnect=4,_netdev`; add bind mount for `/etc/ssh/ssh_known_hosts` (CA trust) as read-only. These become defaults; tfvars can supply optional extras only.
- [x] Pipeline/registry touchpoints: none expected; will confirm no Jenkins job registry updates after Terraform changes.

## Stage 1 – Terraform scaffolding
- [x] Add `default_mounts` + `effective_mounts` locals to `module/jenkins/controller` with baked NFS + ssh-known-hosts mounts; keep optional extra mounts appended.
- [x] Mirror the baked mounts/logic in `module/jenkins/agent`.
- [x] Update mount variable defaults/descriptions in module variables; fmt modules.

## Stage 2 – Pipelines
- [x] Confirm no pipeline `.sh` / `.jenkins` changes required; note defaults still resolve tfvars under `${HOME}/.tfvars/jenkins` now served by baked mounts.

## Stage 3 – Jenkins integration & configs
- [x] Validate Jenkins job registry (`terraform/module/jenkins/config`) needs no updates; note decision in this stage.

## Stage 4 – Validation & docs
- [ ] Agent tests: `terraform fmt -recursive` (done); (if credentials available) `terraform validate` in `terraform/swarm/jenkins/{controller,agent}`.
- [ ] Human tests: run `pipeline/jenkins/controller.sh --plan` and `agent.sh --plan` from a Jenkins node with mounts present; verify ssh to CA-backed hosts works from controller/agent containers.
