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
  endpoint = var.terraform.proxmox.endpoint
  password = var.terraform.proxmox.password
  username = var.terraform.proxmox.username
  random_vm_ids = true
  insecure = true
  ssh {
    agent = true
    # agent_socket = 1022
    username = var.terraform.proxmox.ssh.username
    private_key = file(var.SSH_PRIVATE_KEY)
    node {
      name = var.terraform.proxmox.ssh.node.name
      address = var.terraform.proxmox.ssh.node.address
    }
  }
}