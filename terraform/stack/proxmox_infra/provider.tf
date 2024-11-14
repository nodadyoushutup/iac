terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}
provider "proxmox" {
  endpoint = local.config.proxmox.endpoint
  api_token = local.config.proxmox.api_token
  insecure  = local.config.proxmox.insecure
  ssh {
    agent = local.config.proxmox.ssh.agent
    agent_socket = local.config.proxmox.ssh.agent_socket
    username = local.config.proxmox.ssh.username
    private_key = file(var.PATH_PRIVATE_KEY)
    node {
      name = local.config.proxmox.ssh.node.name
      address = local.config.proxmox.ssh.node.address
    }
  }
}