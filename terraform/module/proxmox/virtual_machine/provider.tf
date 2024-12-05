terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint = "${local.config.proxmox.endpoint.protocol}://${local.config.proxmox.endpoint.ip_address}:${local.config.proxmox.endpoint.port}"
  insecure  = local.config.proxmox.endpoint.insecure
  username = "${local.config.proxmox.auth.username}@${local.config.proxmox.auth.realm}"
  password = local.config.proxmox.auth.password
  ssh {
    private_key = file(local.config.proxmox.ssh.private_key)
    node {
      name = local.config.proxmox.ssh.node.name
      address = local.config.proxmox.ssh.node.address
      port = local.config.proxmox.ssh.node.port
    }
  }
}
