# modules/proxmox/virtual_machine/provider.tf

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint = local.config.provider.proxmox.endpoint
  api_token = local.config.provider.proxmox.api_token
  insecure  = local.config.provider.proxmox.insecure
  ssh {
    agent = local.config.provider.proxmox.ssh.agent
    agent_socket = local.config.provider.proxmox.ssh.agent_socket
    username = local.config.provider.proxmox.ssh.username
    private_key = file("/mnt/workspace/proxmox.pem")
    node {
      name = local.config.provider.proxmox.ssh.node.name
      address = local.config.provider.proxmox.ssh.node.address
    }
  }
}