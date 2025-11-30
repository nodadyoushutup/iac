# SSH CA backhaul access (swarm nodes -> dev)

Issue: Swarm nodes can SSH each other and dev -> swarm works, but swarm -> dev (`nodadyoushutup.internal`) fails with `Permission denied (publickey,password,keyboard-interactive)`.

Goal: Allow CA-authenticated logins from swarm nodes to the dev box.

## Expected state on dev host
- `TrustedUserCAKeys /etc/ssh/user_ca.pub` present once.
- `AuthorizedPrincipalsFile /etc/ssh/authorized_principals/%u` present.
- Principal file `/etc/ssh/authorized_principals/nodadyoushutup` contains `nodadyoushutup`.
- CA fingerprint matches: `70d2a6bba3a141c2b7b44796ab677fddd4d2fe44779ef2ee7fc38cada9baeee1`.

## Steps (run on dev host: nodadyoushutup.internal)
1) Check CA directives: [x]
```bash
sudo grep -nE 'TrustedUserCAKeys|AuthorizedPrincipalsFile' /etc/ssh/sshd_config
sudo grep -n '^TrustedUserCAKeys' /etc/ssh/sshd_config | wc -l   # expect 1
```
If missing/duplicated/wrong path:
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak-$(date +%F_%H%M%S)
tmp=$(mktemp)
sudo awk 'BEGIN{c=0} /^TrustedUserCAKeys[[:space:]]/{c++; if(c>1)next} {print}' /etc/ssh/sshd_config > "$tmp" \
  && sudo mv "$tmp" /etc/ssh/sshd_config
```
Ensure the line `TrustedUserCAKeys /etc/ssh/user_ca.pub` exists; add it near the `AuthorizedPrincipalsFile` if missing.

2) Check principals file: [x]
```bash
sudo stat -c '%U:%G %a %n' /etc/ssh/authorized_principals /etc/ssh/authorized_principals/nodadyoushutup
sudo cat /etc/ssh/authorized_principals/nodadyoushutup
```
If missing/wrong:
```bash
sudo mkdir -p /etc/ssh/authorized_principals
echo nodadyoushutup | sudo tee /etc/ssh/authorized_principals/nodadyoushutup
sudo chown root:root /etc/ssh/authorized_principals /etc/ssh/authorized_principals/nodadyoushutup
sudo chmod 755 /etc/ssh/authorized_principals
sudo chmod 644 /etc/ssh/authorized_principals/nodadyoushutup
```

3) Verify CA pubkey: [x]
```bash
sudo sha256sum /etc/ssh/user_ca.pub     # expect 70d2a6bb...
```
Replace with the source-of-truth CA if it differs.

4) Validate sshd and reload: [x]
```bash
sudo sshd -t
sudo systemctl reload sshd || sudo systemctl reload ssh
sudo systemctl status --no-pager sshd || sudo systemctl status --no-pager ssh
```

5) Test from a swarm node (run on any swarm host): [x]
```bash
ssh -vv nodadyoushutup.internal hostname
```
If it fails, grab logs on dev:
```bash
sudo journalctl -u ssh -n 50 --no-pager
```

6) Optional cleanups on dev: [x]
```bash
sudo find /etc/ssh -maxdepth 1 -type f \( -name 'sshd_config.bak-*' -o -name '*.bak' -o -name '*.old' -o -name '*~' \) -print
sudo rm /etc/ssh/sshd_config.bak-* /etc/ssh/*.bak /etc/ssh/*.old /etc/ssh/*~
```

## Checklist (dev host: nodadyoushutup.internal)
- Step 1: CA directives verified once (`TrustedUserCAKeys` + `AuthorizedPrincipalsFile`) [x]
- Step 2: Principals file exists/perms ok and contains `nodadyoushutup` [x]
- Step 3: CA fingerprint matches `70d2a6bb...` [x]
- Step 4: `sshd -t` clean and service reloaded [x]
- Step 5: Test from swarm node succeeds (`ssh -vv nodadyoushutup.internal hostname`) [x]
- Step 6: Optional backup cleanup in `/etc/ssh` [x]
