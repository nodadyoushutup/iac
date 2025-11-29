# SSH CA Automation

This repository is for running an SSH certificate authority that signs host and user keys. Clone it onto the CA host (this machine) and any other machines that need to request or install signed keys.

## Layout
- `scripts/bootstrap-ca.sh` – generate CA keys in `.keys/` if missing (CA host).
- `scripts/preflight.sh` – verifies the CA host has the required tools and key files in the expected locations.
- `scripts/sign-host-cert.sh` – sign host public keys with the host CA (CA host).
- `scripts/sign-user-cert.sh` – sign user public keys with the user CA (CA host).
- `scripts/install-host-ca.sh` – install the host CA public key into `ssh_known_hosts` on client machines.
- `scripts/install-user-ca.sh` – install the user CA public key and set `TrustedUserCAKeys` on SSH servers.
- `scripts/configure-server-host-cert.sh` – add `HostCertificate` to `sshd_config` for a signed host cert.
- `scripts/reset-ca.sh` – move CA material aside to simulate a fresh clone (CA host).
- `scripts/reset-client.sh` – remove host CA trust from `ssh_known_hosts`.
- `scripts/reset-server.sh` – remove user CA trust from sshd configuration.
- `.keys/` – SSH CA key material kept out of version control; place or generate keys here.
- `PROCESS.md` – step-by-step checklist for which script to run on which machine.

## Requirements
- Bash
- OpenSSH utilities (`ssh-keygen` in particular)

## Getting Started
1. (Optional) Initialize git here if you have not already: `git init`.
2. Generate CA keys into `.keys/` if needed: `scripts/bootstrap-ca.sh`.
3. Run `scripts/preflight.sh` to confirm the CA host has the tools and files wired up correctly.
4. Follow the runbook in `PROCESS.md` for signing and trust configuration (including copying `.pub` keys into `.keys/` on other machines before running install scripts).

## Security Notes
- Private keys and generated certificates are ignored by git via `.gitignore`; keep them out of the repository history.
- Treat this directory as sensitive on the CA host and keep clones private on other machines.
