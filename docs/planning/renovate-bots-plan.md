## Goal
Rehome the MinIO docker compose assets into a new `docker/state` directory, extend the compose stack to run two Renovate bots (arm-focused and default/amd) with the necessary global configs, and fix the repo-level Renovate config so platform warnings disappear. Target outcome: after pulling the changes on the host that runs the compose stack, `docker compose up -d` brings up MinIO plus both Renovate bots with correct platform scoping, and repo-level config passes validation.

## Stage 0 – Preparation
- [x] Confirm target directories and scopes: `docker/minio` → rename to `docker/state`; update compose file inside; adjust repo-level `.github/renovate.json`.
- [x] Taxonomy/provider decision: no Terraform provider; this is a local Docker Compose stack. Documented here; no provider addition needed.
- [x] Reference patterns to clone: use existing `docker/minio/docker-compose.yaml` as base for `docker/state/docker-compose.yaml`; no pipeline/templates needed.
- [x] TFVARS/backend inputs required? None for this change (compose-only). Verified `ls ~/.tfvars` shows only existing service tfvars/backends; nothing new required.
- [x] Jenkins/pipeline surfaces: none; compose-only. Note no Jenkins job updates planned.
- [x] Commands to prove files/dirs exist pre-change:
  - `ls docker/minio` → `docker-compose.yaml`
  - `ls .github/renovate.json` → present
- [x] Plan global Renovate config needs: two bots with distinct global configs (one `docker.platform=linux/arm64` for Swarm services, one default/amd), each with repo allowlist covering `nodadyoushutup/homelab`.
- [x] Document tfvars/backend placeholders (N/A) so reviewers know nothing is pending there.

## Stage 1 – Implementation: Move MinIO assets
- [x] Rename `docker/minio` to `docker/state` (update any internal path references if present in compose or docs).
- [x] Ensure MinIO compose content is preserved under `docker/state/docker-compose.yaml`.
- [x] Update docs/readme references if `docker/minio` is mentioned elsewhere (grep check). Updated `AGENTS.md` and `docs/wiki/MinIO.md` paths/commands to `docker/state`.

## Stage 2 – Implementation: Compose updates & Renovate bots
- [x] Extend `docker/state/docker-compose.yaml` to add two Renovate services:
  - Bot A (arm): uses global config file with `docker.platform=linux/arm64`, repo allowlist includes this repo.
  - Bot B (default/amd): uses default platform (or explicit `linux/amd64` if desired), repo allowlist includes this repo.
- [x] Add per-bot config files under `docker/state/renovate-arm.json` and `docker/state/renovate-amd.json`, containing token/auth placeholders, platform setting (arm bot only), and repo allowlist.
- [x] Ensure compose sets env mounts/secrets for tokens (`GITHUB_PAT` shared), and binds config files with restart policy.
- [x] Comments in compose label which bot is arm vs default; tokens are required via env interpolation.

## Stage 3 – Repo Renovate config fixes
- [x] Update `.github/renovate.json` to remove unsupported `docker.platform` keys (warnings) while retaining allowed versions and other rules.
- [x] Add notes pointing to the bot-global configs for platform selection (see `docs/swarm-platform-notes.md`).
- [x] Validate config locally: `npx renovate-config-validator` attempted; `npx` not available in this environment—operator to run validator on a node with Node/npx installed.

## Stage 4 – Validation & docs
- [ ] Agent tests (what Codex can run): lint/validate compose (`docker compose config` in `docker/state`), renovate config validation if tool is available.
- [ ] Human tests (operator on target host):
  - Run `docker compose up -d` inside `docker/state`; confirm containers `renovate-arm` and `renovate-amd` (names TBD) healthy.
  - Check Renovate logs for each bot show correct platform setting.
  - Confirm MinIO still starts and backend state intact.
- [ ] Documentation: note new `docker/state` location, bot config files, and how to set tokens/env in readme or comment headers.

## Notes
- Platform selection must live in bot-global config; repo-level `docker.platform` is invalid in hosted Renovate. Two bots with separate globals allow mixed arch resolution.
- No tfvars/backend changes are needed; this change is compose + repo config only.
