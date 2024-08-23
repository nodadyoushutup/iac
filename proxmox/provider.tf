# infrastructure/proxmox/provider./tf

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}
provider "proxmox" {
  endpoint = local.provider.proxmox.endpoint
  api_token = local.provider.proxmox.api_token
  insecure  = local.provider.proxmox.insecure
  ssh {
    agent = local.provider.proxmox.ssh.agent
    agent_socket = local.provider.proxmox.ssh.agent_socket
    username = local.provider.proxmox.ssh.username
    private_key = file("/mnt/workspace/proxmox.pem")
    node {
      name = local.provider.proxmox.ssh.node.name
      address = local.provider.proxmox.ssh.node.address
    }
  }
}