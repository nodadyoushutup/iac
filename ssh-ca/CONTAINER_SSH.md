# SSH CA in Containers (Jenkins on Swarm)

Goal: keep CA setup on the host node, but let ephemeral Jenkins controller/agent containers use SSH to other machines without redoing CA trust in every build.

## What containers need
- A way to verify SSH servers: host CA public key added to `ssh_known_hosts` (via `@cert-authority` entry).
- A way to present client credentials: either an SSH private key or access to an SSH agent that holds one.

## Techniques to pass trust and keys into containers
- Bind-mount host trust: mount the host’s `/etc/ssh/ssh_known_hosts` (or a repo-provided `known_hosts` file containing the `@cert-authority` line) into the container read-only:
  ```
  docker run ... -v /etc/ssh/ssh_known_hosts:/etc/ssh/ssh_known_hosts:ro ...
  ```
- Ship trust as a Docker config/secret: store `host_ca.pub` (or a prebuilt `ssh_known_hosts` with `@cert-authority`) as a Swarm config and mount it into the container at `/etc/ssh/ssh_known_hosts`.
- Bake trust into the image: copy the host CA public key into `/etc/ssh/ssh_known_hosts` in the Dockerfile. This is static, so update the image if the CA rotates.
- Use SSH agent forwarding from host to container: bind-mount the host agent socket (e.g., `-v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent`) so the container can use host-held private keys without copying them in.
- Provide keys via secrets/credentials: inject a per-role private key as a Docker secret mounted at runtime, or for Jenkins use the Credentials + SSH Agent plugin so builds get a private key without baking it into the image.

## Jenkins-specific notes (controller/agents on Swarm)
- Controller and agents can share a base image that already contains the CA trust file (`/etc/ssh/ssh_known_hosts` with `@cert-authority ... host_ca.pub`).
- For agents launched by Jenkins, use the SSH Agent plugin to expose an SSH key to builds; combine with the baked/bound trust file so host verification works.
- If agents run as Docker Swarm services, attach the trust file via a Swarm config/secret mount; attach the agent socket or a secret key for authentication.
- Avoid baking private keys into images. Prefer agent sockets, Jenkins credentials, or Swarm secrets with tight scope.

## Minimal pattern that works well
1) Create a `known_hosts` file on the host containing the `@cert-authority` line for your host CA.
2) Mount that file read-only into controller/agent containers at `/etc/ssh/ssh_known_hosts`.
3) Expose an SSH key to the containers via agent forwarding or Jenkins credentials/SSH Agent plugin.
4) Use `ssh -o StrictHostKeyChecking=yes` normally inside the containers; host verification will succeed because of the CA entry.
