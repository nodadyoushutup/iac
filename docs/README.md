# NoDadYouShutUp Infrastructure as Code

# Sudoers
## Modify file
Match contents of `sudoers`
```bash
sudo nano /etc/sudoers
```

# Network
## Modify file
Match file contents of `50-cloud-init.yaml`
```bash
sudo nano /etc/netplan/50-cloud-init.yaml
```

## Apply network configuration

```bash
sudo netplan apply
```

## Set hostname
```bash
sudo hostnamectl set-hostname cicd
```