# SSH CA Runbook

All commands assume you are in the repo root after cloning. CA private keys stay on the CA host. Public keys can be copied to other machines in `.keys/` as needed.

Vocabulary:
- CA host: the machine that holds the CA private keys and signs things (this repo is cloned here).
- SSH server: any machine that accepts incoming SSH connections (may or may not be the CA host).
- Client: any machine that initiates SSH connections into SSH servers.

## Step 1: Start from nothing (on CA host)
1) Install prerequisites: `git`, `ssh-keygen` (OpenSSH).  
2) Clone this repo:  
   ```
   git clone <repo-url> ssh-ca
   cd ssh-ca
   ```
3) Make sure `.keys/` exists (it will after clone) and is empty.

## Step 2: Create or reuse CA keys (on CA host)
Run the bootstrap script (makes `.keys/host_ca` and `.keys/user_ca` if missing):
```
scripts/bootstrap-ca.sh
```

## Step 3: Verify CA host is ready
```
scripts/preflight.sh
```
You should see all [OK] checks.
If you see an [X]:
- Missing commands (`ssh`/`ssh-keygen`): install OpenSSH tools (Ubuntu example): `sudo apt-get update && sudo apt-get install -y openssh-client`.
- Missing key files: run `scripts/bootstrap-ca.sh` or drop your existing keys into `.keys/`.
- Permissions too open: lock them down, e.g., `chmod 600 .keys/host_ca .keys/user_ca`.
Then rerun `scripts/preflight.sh`.

## Step 4: Sign host keys (repeat for each SSH server)
Only the CA host performs the signing. SSH servers only provide their host public key and later receive the signed cert.

If the host key file is missing on the SSH server, regenerate host keys first:
```
sudo dpkg-reconfigure openssh-server    # Ubuntu/Debian: regenerates /etc/ssh/ssh_host_* keys
```

1) On the SSH server, fetch its host public key to your workstation (or directly to the CA host). Example for ed25519:
   - View it:
     ```
     sudo cat /etc/ssh/ssh_host_ed25519_key.pub
     ```
   - Or copy it straight to the CA host:
     ```
     scp /etc/ssh/ssh_host_ed25519_key.pub ca-host:/path/to/ssh-ca/.keys/server1_host.pub
     ```
     (replace `ca-host` with the CA host's SSH target)
2) If you copied the text manually, save it on the CA host as `.keys/server1_host.pub`.
3) On the CA host, sign it:
   ```
   scripts/sign-host-cert.sh -k .keys/server1_host.pub -n server1.example.com
   ```
   This writes `.keys/server1_host-cert.pub`.
4) On the CA host, copy the generated cert back to the SSH server:
   ```
   scp .keys/server1_host-cert.pub server1.example.com:/etc/ssh/ssh_host_ed25519_key-cert.pub
   ```
5) On the SSH server, update sshd to use the cert and reload:
   ```
   sudo scripts/configure-server-host-cert.sh -c /etc/ssh/ssh_host_ed25519_key-cert.pub
   sudo systemctl reload sshd || sudo systemctl reload ssh
   ```

## Step 5: Sign user keys (repeat for each user)
1) Get the user's public key onto the CA host (save to `.keys/alice.pub` for example).
2) Sign it:
   ```
   scripts/sign-user-cert.sh -k .keys/alice.pub -n alice
   ```
   This writes `.keys/alice-cert.pub`.
3) Give `alice-cert.pub` back to the user to place next to their private key (same directory as `id_ed25519`).

## Step 6: Install host CA trust on client machines (machines that SSH into servers)
1) Clone this repo on the client and `cd` into it.
2) Copy `host_ca.pub` from the CA host into `.keys/host_ca.pub` on the client.
3) Install trust (optionally scope with `-p`):
   ```
   sudo scripts/install-host-ca.sh [-p '*.example.com']
   ```

## Step 7: Install user CA trust on SSH servers (machines that accept SSH logins)
1) Clone this repo on the SSH server and `cd` into it.
2) Copy `user_ca.pub` from the CA host into `.keys/user_ca.pub` on the server.
3) Install trust:
   ```
   sudo scripts/install-user-ca.sh
   ```
4) Reload sshd:
   ```
   sudo systemctl reload sshd || sudo systemctl reload ssh
   ```

## Step 8: Reset/teardown (for testing)
- CA host: `scripts/reset-ca.sh` (moves CA keys and generated certs into `reset-backups/`).
- Client machines: `sudo scripts/reset-client.sh` (removes host CA trust or restores backup).
- SSH servers: `sudo scripts/reset-server.sh` (removes `TrustedUserCAKeys`/user CA file or restores backup), then reload sshd.
