terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 0.2.0"
    }
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint = local.config.provider.proxmox.endpoint
  insecure  = local.config.provider.proxmox.insecure
  username = local.config.provider.proxmox.username
  password = local.config.provider.proxmox.password
  ssh {
    private_key = file(local.config.path.private_key)
    node {
      name = local.config.provider.proxmox.ssh.node.name
      address = local.config.provider.proxmox.ssh.node.address
      port = local.config.provider.proxmox.ssh.node.port
    }
  }
}
