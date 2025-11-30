# SSH CA

Source of truth for the SSH certificate authority workflow. Every machine mounts the same `~/code/homelab` repo via NFS from `truenas.internal`, so the `ssh-ca/` folder is available everywhere. Default SSH access is already enabled via authorized_keys; this CA layer standardizes trust and certificates across hosts and containers.

## Workflow overview

- Operate from the development machine (`nodadyoushutup.internal`) and SSH to other hosts as needed; all hosts see the same repo path.
- CA materials live in `ssh-ca/.keys` (ignored by git). Host/user CA keys stay on the CA host; staging files (`*-cert.pub`, copied `*.pub`) can be created anywhere and removed after use.
- Trust is installed with `@cert-authority * ...` in `/etc/ssh/ssh_known_hosts` so all hostnames covered by the pattern are verified by the CA.
- SSH servers trust the user CA via `TrustedUserCAKeys /etc/ssh/user_ca.pub`; host certificates are enabled via `HostCertificate` entries.
- Containers inherit trust by mounting `/etc/ssh/ssh_known_hosts` (or a prebuilt known_hosts with the CA line) and consuming an SSH key/agent.

## Essential scripts (from `ssh-ca/`)

- `scripts/bootstrap-ca.sh` – create `host_ca` / `user_ca` in `.keys/` if missing.
- `scripts/preflight.sh` – sanity check keys/permissions and required tools.
- `scripts/sign-host-cert.sh` / `scripts/sign-user-cert.sh` – sign host/user public keys; outputs `*-cert.pub`.
- `scripts/install-host-ca.sh` – add `@cert-authority * <host_ca.pub>` to `/etc/ssh/ssh_known_hosts` (supports custom patterns).
- `scripts/install-user-ca.sh` – install user CA pubkey and append `TrustedUserCAKeys` to `sshd_config`; reload sshd after.
- `scripts/configure-server-host-cert.sh` – add `HostCertificate` to `sshd_config` for a signed host cert; reload sshd after.
- Cleanup/reset: `scripts/reset-ca.sh` (move CA material aside on the CA host), `scripts/reset-client.sh` (remove host CA trust), `scripts/reset-server.sh` (remove user CA trust).

## Standard operating procedure

1. On the CA host (any machine, typically the dev box), run `scripts/bootstrap-ca.sh` then `scripts/preflight.sh`.
2. For each SSH server: copy its host public key into `ssh-ca/.keys/<host>_host.pub`, sign with `scripts/sign-host-cert.sh`, copy `*-cert.pub` back to `/etc/ssh/ssh_host_ed25519_key-cert.pub`, run `scripts/configure-server-host-cert.sh`, reload sshd.
3. For each user: place their `*.pub` in `.keys/`, sign with `scripts/sign-user-cert.sh`, return the `*-cert.pub` to the user.
4. On every client machine: `sudo scripts/install-host-ca.sh` (defaults to `@cert-authority *`). On every SSH server: `sudo scripts/install-user-ca.sh` then reload sshd.
5. Containers/agents: mount a known_hosts containing the CA line (or `/etc/ssh/ssh_known_hosts`) read-only and expose an SSH key/agent; no extra CA steps needed inside containers.

## Cleanup guidance

- Keep: CA private/public keys (`.keys/host_ca*`, `.keys/user_ca*`), installed trust files (`/etc/ssh/ssh_known_hosts` CA line, `/etc/ssh/user_ca.pub`, `TrustedUserCAKeys` entry), server host certs/keys under `/etc/ssh/`.
- Remove when done: transient `ssh-ca/.keys/*-cert.pub` copies after installing, copied host/user `*.pub` inputs that are no longer needed, any per-host known_hosts or cert files staged under the repo.
- Automated cleanup:
  - CA host: `ssh-ca/scripts/reset-ca.sh` moves CA/cert files into `reset-backups/` (use with care).
  - Clients: `sudo ssh-ca/scripts/reset-client.sh` to remove host CA trust.
  - Servers: `sudo ssh-ca/scripts/reset-server.sh` to remove `TrustedUserCAKeys`/user CA pub and restore backups.
- Manual sweep (non-destructive to CA keys) from repo root:
  ```bash
  find ssh-ca/.keys -maxdepth 1 -type f ! -name 'host_ca' ! -name 'host_ca.pub' ! -name 'user_ca' ! -name 'user_ca.pub' -delete
  ```
  Run on any host to clear staging artifacts while keeping CA keys.

## Notes and references

- Machines/paths: see [[Machines]] for host list, NFS mount (`~/code/homelab`), and `ssh` connectivity expectations.
- Secrets/tfvars/env: see [[Secrets]]; CA keys stay outside git under `ssh-ca/.keys`.
- Swarm/containers: see [[Docker Swarm]] for pipeline patterns and how to mount trust into services.
