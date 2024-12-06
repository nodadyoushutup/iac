terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}


provider "proxmox" {
  endpoint = "${local.proxmox.endpoint.protocol}://${local.proxmox.endpoint.ip_address}:${local.proxmox.endpoint.port}"
  insecure  = local.proxmox.endpoint.insecure
  password = local.proxmox.auth.password
  username = "${local.proxmox.auth.username}@${local.proxmox.auth.realm}"
  ssh {
    agent = local.proxmox.ssh.agent.enabled
    agent_socket = local.proxmox.ssh.agent.socket
    private_key = coalesce(try(file(local.proxmox.ssh.private_key), null), local.default.private_key)
    node {
      name = local.proxmox.ssh.node.name
      address = local.proxmox.ssh.node.address
      port = local.proxmox.ssh.node.port
    }
  }
}