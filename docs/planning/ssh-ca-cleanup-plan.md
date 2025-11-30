# SSH CA cleanup (per-node runbook)

Goal: remove remediation leftovers and confirm CA-based SSH is clean. Run these steps on each node.

## Scope / expected state
- `TrustedUserCAKeys /etc/ssh/user_ca.pub` defined once; `AuthorizedPrincipalsFile /etc/ssh/authorized_principals/%u`.
- User principal for `nodadyoushutup` stored at `/etc/ssh/authorized_principals/nodadyoushutup`.
- Expected SHA256s: user CA `70d2a6bba3a141c2b7b44796ab677fddd4d2fe44779ef2ee7fc38cada9baeee1`; dev key `3f82837ac7b5194334e6d7642f34bd49e9710552fdcde2432205f62d387ba581`.

## Steps (verify → correct if needed)

1) Dedupe CA directives in `sshd_config`
```bash
sudo grep -nE 'TrustedUserCAKeys|AuthorizedPrincipalsFile' /etc/ssh/sshd_config
sudo grep -n '^TrustedUserCAKeys' /etc/ssh/sshd_config | wc -l   # expect 1
```
If count > 1 or path wrong:
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak-$(date +%F_%H%M%S)
tmp=$(mktemp)
sudo awk 'BEGIN{c=0} /^TrustedUserCAKeys[[:space:]]/{c++; if(c>1)next} {print}' /etc/ssh/sshd_config > "$tmp" \
  && sudo mv "$tmp" /etc/ssh/sshd_config
```

2) Authorized principals path and perms
```bash
sudo stat -c '%U:%G %a %n' /etc/ssh/authorized_principals /etc/ssh/authorized_principals/nodadyoushutup
sudo cat /etc/ssh/authorized_principals/nodadyoushutup                # expect only nodadyoushutup
```
If missing or perms off:
```bash
sudo mkdir -p /etc/ssh/authorized_principals
echo nodadyoushutup | sudo tee /etc/ssh/authorized_principals/nodadyoushutup
sudo chown root:root /etc/ssh/authorized_principals /etc/ssh/authorized_principals/nodadyoushutup
sudo chmod 755 /etc/ssh/authorized_principals
sudo chmod 644 /etc/ssh/authorized_principals/nodadyoushutup
```

3) Confirm user CA fingerprint
```bash
sudo sha256sum /etc/ssh/user_ca.pub     # expect 70d2a6bb...
```
If mismatch, replace with the source-of-truth CA pubkey before proceeding.

4) Trim leftover backups and temp files (manual confirmation)
```bash
sudo find /etc/ssh -maxdepth 1 -type f \( -name 'sshd_config.bak-*' -o -name '*.bak' -o -name '*.old' -o -name '*~' \) -print
```
If the listed backups are no longer needed:
```bash
sudo rm /etc/ssh/sshd_config.bak-* /etc/ssh/*.bak /etc/ssh/*.old /etc/ssh/*~
```

5) Client config and key inventory (per user on the node)
```bash
stat -c '%a %n' ~/.ssh ~/.ssh/config
sed -n '1,80p' ~/.ssh/config
ls -1 ~/.ssh/id_* 2>/dev/null
```
To normalize the client block and limit key attempts:
```bash
cat <<'EOF' > ~/.ssh/config
Host *.internal
  User nodadyoushutup
  IdentityFile ~/.ssh/id_ed25519
  CertificateFile ~/.ssh/id_ed25519-cert.pub
  IdentitiesOnly yes
  PreferredAuthentications publickey
EOF
chmod 600 ~/.ssh/config
# Keep only the required client files (config, ed25519 key/cert, known_hosts, optional known_hosts.old):
KEEP='config id_ed25519 id_ed25519.pub id_ed25519-cert.pub known_hosts known_hosts.old'
for f in "$HOME/.ssh/"* "$HOME/.ssh/".*; do
  bn=$(basename "$f")
  [[ "$bn" =~ ^(\.|\.\.|config|id_ed25519|id_ed25519\.pub|id_ed25519-cert\.pub|known_hosts|known_hosts\.old)$ ]] && continue
  [ -e "$f" ] && rm -rf "$f"
done
# If host CA is trusted via /etc/ssh/ssh_known_hosts, you can truncate user known_hosts to avoid stale per-host pins:
# : > ~/.ssh/known_hosts
# Remove known_hosts.old unless you need the backup:
[ -f ~/.ssh/known_hosts.old ] && rm ~/.ssh/known_hosts.old
chmod 700 ~/.ssh
```

6) Validate and reload
```bash
sudo sshd -t
sudo systemctl reload sshd || sudo systemctl reload ssh
sudo systemctl status --no-pager sshd || sudo systemctl status --no-pager ssh
ssh -vv nodadyoushutup@$(hostname -f) exit
sudo journalctl -u ssh -n 20 --no-pager | grep -i 'Accepted publickey' | tail -n 5
```

7) Cluster spot-check (optional, run from one node)
```bash
SSH_OPTS='-o StrictHostKeyChecking=accept-new'
for src in swarm-cp-0.internal swarm-wk-0.internal swarm-wk-1.internal swarm-wk-2.internal swarm-wk-3.internal; do
  for dst in swarm-cp-0.internal swarm-wk-0.internal swarm-wk-1.internal swarm-wk-2.internal swarm-wk-3.internal; do
    echo "Testing $src -> $dst"
    ssh $SSH_OPTS "$src" "ssh -o StrictHostKeyChecking=accept-new $dst hostname" || echo "FAIL $src -> $dst"
  done
done
echo "Testing dev nodadyoushutup.internal -> swarm nodes"
for dst in swarm-cp-0.internal swarm-wk-0.internal swarm-wk-1.internal swarm-wk-2.internal swarm-wk-3.internal; do
  echo "Testing dev -> $dst"
  ssh $SSH_OPTS "$dst" hostname || echo "FAIL dev -> $dst"
done
echo "Testing swarm nodes -> dev nodadyoushutup.internal"
for src in swarm-cp-0.internal swarm-wk-0.internal swarm-wk-1.internal swarm-wk-2.internal swarm-wk-3.internal; do
  echo "Testing $src -> dev"
  ssh $SSH_OPTS "$src" "ssh -o StrictHostKeyChecking=accept-new nodadyoushutup.internal hostname" || echo "FAIL $src -> dev"
done
```

## Per-node checklist
Nodes: `dev` (nodadyoushutup), `swarm-cp-0`, `swarm-wk-0`, `swarm-wk-1`, `swarm-wk-2`, `swarm-wk-3`.

- 1) Dedupe CA directives: dev [ ] cp-0 [ ] wk-0 [ ] wk-1 [ ] wk-2 [ ] wk-3 [ ]
- 2) Authorized principals path/perms: dev [ ] cp-0 [ ] wk-0 [ ] wk-1 [ ] wk-2 [ ] wk-3 [ ]
- 3) User CA fingerprint matches: dev [ ] cp-0 [ ] wk-0 [ ] wk-1 [ ] wk-2 [ ] wk-3 [ ]
- 4) Backups/temp files trimmed: dev [ ] cp-0 [ ] wk-0 [ ] wk-1 [ ] wk-2 [ ] wk-3 [ ]
- 5) Client config/keys normalized: dev [ ] cp-0 [ ] wk-0 [ ] wk-1 [ ] wk-2 [ ] wk-3 [ ]
- 6) Validate + reload + local ssh + log check: dev [ ] cp-0 [ ] wk-0 [ ] wk-1 [ ] wk-2 [ ] wk-3 [ ]
- 7) Cluster spot-check (run once from any node): matrix [ ]
