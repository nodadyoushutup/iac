# Swarm Node Onboarding

Manual runbook for adding new Swarm nodes after the machine is onboarded to the SSH CA (see [[SSH-CA]]). Copy/paste config and commands directly on the target host—no automation or scp.

## Prerequisites

- Finish SSH CA onboarding from [[SSH-CA]] so the node already has host/user CA trust and certs.
- Networking: static IP + DNS entry (`<name>.internal`) reachable from all swarm nodes and the dev box. Add/update the entry in [[Machines]] once assigned.
- Access: `nodadyoushutup` user present with sudo, `~/.ssh/authorized_keys` populated (paste the key manually) and `chmod 600 ~/.ssh/authorized_keys`. Verify with `ssh <host> hostname` from the dev box.
- Packages: `sudo apt update && sudo apt install -y curl ca-certificates gnupg nfs-common`; set the hostname before joining (`sudo hostnamectl set-hostname <name>`).
- NFS mounts (from `truenas.internal`):
  ```bash
  sudo install -d /home/nodadyoushutup/{code,.tfvars,.kube,.jenkins}
  cat <<'EOF' | sudo tee -a /etc/fstab
  192.168.1.100:/mnt/eapp/home/code        /home/nodadyoushutup/code  nfs  nfsvers=4.2,proto=tcp,rsize=1048576,wsize=1048576,hard,intr,noatime,actimeo=1,nconnect=4,_netdev  0 0
  EOF
  sudo mount -a
  ```
  Root_squash reminder: if a command needs `sudo` on a file from the NFS mount, copy it to `/tmp` first, run the command there, then move the result back.
- Docker Engine 28.x installed and enabled. If the Docker repo is not present, install it once:
  ```bash
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker nodadyoushutup
  sudo systemctl enable --now docker
  ```

## Manual join procedure

1. **Prep and validate the host**
   - Reboot after Docker install if prompted.
   - Confirm NFS mounts are present: `ls ~/code/homelab ~/code/homelab/docs`.
   - Sanity check SSH from dev: `ssh <new-host> hostname`.

2. **Grab the join command from the controller**
   - From the dev box: `ssh swarm-cp-0.internal "docker swarm join-token worker"` (or `manager` if you really need another manager). Copy the full `docker swarm join ...` line.

3. **Join the swarm (on the new host)**
   - Run the copied join command, adding `--advertise-addr <new-host-ip>` if it is not already present.
   - Verify locally: `docker info | grep 'Swarm: active'`.

4. **Post-join checks (from the controller)**
   - `ssh swarm-cp-0.internal "docker node ls"` to confirm the node shows `Ready`.
   - Apply labels per [[Docker-Node-Labels|Docker Node Labels]], e.g. `ssh swarm-cp-0.internal "docker node update --label-add role=<role> <new-host>"`.
   - If the node should be drained/paused during setup: `docker node update --availability drain <new-host>` and switch back to `active` when ready.

5. **Connectivity spot-check**
   - From the controller: `ssh swarm-cp-0.internal "ssh -o StrictHostKeyChecking=accept-new <new-host> hostname"`.
   - Optionally run a short inter-node check to/from the new host only, not the full matrix, to avoid unnecessary churn.

6. **Document the addition**
   - Add the node to [[Machines]] with IP/OS/arch/Docker version and intended role/labels.
   - Note any one-off quirks (storage layout, NIC names, BIOS/UEFI oddities) inline in the Machines table or as a footnote.

Keep this flow manual—no scp, no helper scripts. Everything is expected to be pasted and run directly on the target box.
