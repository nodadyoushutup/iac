# SSH CA (Machine Onboarding)

Manual, script-free process to bring any machine (swarm nodes, Proxmox, TrueNAS, new dev boxes) under the SSH certificate authority so hosts can trust each other and user certs work. Keep this independent from Swarm joining—finish these steps first, then follow [[Swarm-Node-Onboarding|Swarm Node Onboarding]] if the machine will run Docker Swarm.

## CA materials (one-time)

- Pick a CA host (usually the dev box) and keep CA keys off git and off the NFS share. Suggested path: `~/.ssh-ca/`.
- Create the directory and lock it down:
  ```bash
  install -d -m 700 ~/.ssh-ca
  ```
- If CA keys already exist, reuse them. To create new ones (only if you intend to reissue everything):
  ```bash
  ssh-keygen -t ed25519 -f ~/.ssh-ca/host_ca -N '' -C 'homelab host ca'
  ssh-keygen -t ed25519 -f ~/.ssh-ca/user_ca -N '' -C 'homelab user ca'
  chmod 600 ~/.ssh-ca/host_ca ~/.ssh-ca/user_ca
  chmod 644 ~/.ssh-ca/host_ca.pub ~/.ssh-ca/user_ca.pub
  ```

## Onboard a machine to the CA

1. **Base access (on the target host)**
   - Ensure the `nodadyoushutup` user exists with sudo.
   - Manually paste the authorized key: `mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat <<'EOF' > ~/.ssh/authorized_keys` then paste the key and `chmod 600 ~/.ssh/authorized_keys`.

2. **Collect the host public key**
   - On the target host: `sudo cat /etc/ssh/ssh_host_ed25519_key.pub` and copy the entire line.
   - On the CA host, paste it into `/tmp/<host>_host.pub`.

3. **Sign the host key (on the CA host)**
   ```bash
   ssh-keygen -s ~/.ssh-ca/host_ca -h \
     -I <host>-$(date +%Y%m%d) \
     -n <host>,<host>.internal,<host-ip> \
     -V -1w:+52w \
     /tmp/<host>_host.pub
   ```
   This writes `/tmp/<host>_host-cert.pub`.

4. **Install the host certificate (on the target host)**
   - On the CA host, open `/tmp/<host>_host-cert.pub` and copy its contents.
   - On the target host, paste it:
     ```bash
     sudo tee /etc/ssh/ssh_host_ed25519_key-cert.pub <<'EOF'
     <paste host cert here>
     EOF
     ```
   - Ensure `sshd_config` references the key and cert (add if missing, avoid duplicates):
     ```bash
     sudo sh -c "grep -q '^HostKey /etc/ssh/ssh_host_ed25519_key' /etc/ssh/sshd_config || echo 'HostKey /etc/ssh/ssh_host_ed25519_key' >> /etc/ssh/sshd_config"
     sudo sh -c "grep -q '^HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub' /etc/ssh/sshd_config || echo 'HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub' >> /etc/ssh/sshd_config"
     sudo systemctl restart sshd
     ```

5. **Install user CA trust (on the target host)**
   - On the CA host, open `~/.ssh-ca/user_ca.pub` and copy its contents.
   - On the target host, paste it:
     ```bash
     sudo tee /etc/ssh/user_ca.pub <<'EOF'
     <paste user_ca.pub here>
     EOF
     ```
   - Ensure `TrustedUserCAKeys` is set:
     ```bash
     sudo sh -c "grep -q '^TrustedUserCAKeys /etc/ssh/user_ca.pub' /etc/ssh/sshd_config || echo 'TrustedUserCAKeys /etc/ssh/user_ca.pub' >> /etc/ssh/sshd_config"
     sudo systemctl restart sshd
     ```

6. **Install host CA trust on every client (including the new machine)**
   - On the CA host, run `echo "@cert-authority * $(cat ~/.ssh-ca/host_ca.pub)"` and copy the output line.
   - On each client, append it:
     ```bash
     echo "@cert-authority * <paste host_ca.pub line here>" | sudo tee -a /etc/ssh/ssh_known_hosts
     ```
   This enables host verification without per-host known_hosts entries.

7. **Issue a user certificate (optional but recommended)**
   - On the CA host (using your existing public key):
     ```bash
     ssh-keygen -s ~/.ssh-ca/user_ca \
       -I nodadyoushutup-$(date +%Y%m%d) \
       -n nodadyoushutup \
       -V -1w:+52w \
       ~/.ssh/id_ed25519.pub
     ```
     This writes `~/.ssh/id_ed25519-cert.pub`.
   - Use the cert alongside the key when connecting: `ssh -i ~/.ssh/id_ed25519 -o CertificateFile=~/.ssh/id_ed25519-cert.pub <host>`.
   - If home directories are not shared (for example on appliances), copy the cert to the matching `~/.ssh/` path on that machine with the same permissions as the private key.

8. **Validate**
   - From the dev box: `ssh -o StrictHostKeyChecking=yes <host> hostname`.
   - From the new host: `ssh -o StrictHostKeyChecking=yes nodadyoushutup.internal hostname` and another swarm node to confirm mutual trust.

9. **Document**
   - Add/update the entry in [[Machines]] with IP/role/OS/arch/Docker version (if applicable) and note that SSH CA is installed.

## Notes

- Keep CA private keys backed up and off shared mounts. If keys are rotated, every host certificate and trust file must be refreshed.
- Prefer `cat | tee` copy/paste over `scp` to avoid failures; if root access to `/etc/ssh` is blocked by NFS root_squash, copy the file to `/tmp` first, then move it with `sudo`.
- For post-rollout hygiene on existing nodes, follow [[SSH-CA-Cleanup|SSH CA Cleanup]].
