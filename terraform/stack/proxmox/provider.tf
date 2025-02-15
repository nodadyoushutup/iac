terraform {
    required_providers {
        proxmox = {
            source = "bpg/proxmox"
        }
    }

    backend "s3" {
      key = "proxmox.tfstate"
    }
}

provider "proxmox" {
  endpoint = var.terraform_provider.proxmox.endpoint
  password = var.terraform_provider.proxmox.password
  username = var.terraform_provider.proxmox.username
  random_vm_ids = true
  insecure = true
  ssh {
    agent = true
    # agent_socket = 1022
    username = var.terraform_provider.proxmox.ssh.username
    private_key = file(var.SSH_PRIVATE_KEY)
    node {
      name = var.terraform_provider.proxmox.ssh.node.name
      address = var.terraform_provider.proxmox.ssh.node.address
    }
  }
}