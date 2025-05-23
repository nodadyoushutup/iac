terraform {
    backend "s3" {
        key = "debug.tfstate"
    }
    required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}


provider "proxmox" {
  endpoint = local.config.terraform.proxmox.endpoint
  password = local.config.terraform.proxmox.password
  username = local.config.terraform.proxmox.username
  random_vm_ids = true
  insecure = true
  ssh {
    agent = true
    # agent_socket = 1022
    username = local.config.terraform.proxmox.ssh.username
    private_key = file(local.config.terraform.proxmox.ssh.private_key)
    node {
      name = local.config.terraform.proxmox.ssh.node.name
      address = local.config.terraform.proxmox.ssh.node.address
    }
  }
}