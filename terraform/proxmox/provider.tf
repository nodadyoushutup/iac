terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
    linux = {
      source = "TelkomIndonesia/linux"
    }
  }
}

provider "proxmox" {
  endpoint = "${local.config.data.proxmox.endpoint.protocol}://${local.config.data.proxmox.endpoint.ip_address}:${local.config.data.proxmox.endpoint.port}"
  insecure  = local.config.data.proxmox.endpoint.insecure
  password = local.config.data.proxmox.auth.password
  username = "${local.config.data.proxmox.auth.username}@${local.config.data.proxmox.auth.realm}"
  random_vm_ids = true
  ssh {
    agent = local.config.data.proxmox.ssh.agent.enabled
    agent_socket = local.config.data.proxmox.ssh.agent.socket
    private_key = coalesce(try(file(local.config.data.proxmox.ssh.private_key), null), local.default.private_key)
    node {
      name = local.config.data.proxmox.ssh.node.name
      address = local.config.data.proxmox.ssh.node.address
      port = local.config.data.proxmox.ssh.node.port
    }
  }
}