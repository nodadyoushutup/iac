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
  password = local.config.proxmox.auth.password
  username = "${local.config.proxmox.auth.username}@${local.config.proxmox.auth.realm}"
  ssh {
    agent = local.config.proxmox.ssh.agent.enabled
    agent_socket = local.config.proxmox.ssh.agent.socket
    private_key = file(var.PATH_PRIVATE_KEY)
    node {
      name = local.config.proxmox.ssh.node.name
      address = local.config.proxmox.ssh.node.address
      port = local.config.proxmox.ssh.node.port
    }
  }
}