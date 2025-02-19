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
  endpoint = local.terraform.proxmox.endpoint
  password = local.terraform.proxmox.password
  username = local.terraform.proxmox.username
  random_vm_ids = true
  insecure = true
  ssh {
    agent = true
    # agent_socket = 1022
    username = local.terraform.proxmox.ssh.username
    private_key = file(local.ssh_private_key)
    node {
      name = local.terraform.proxmox.ssh.node.name
      address = local.terraform.proxmox.ssh.node.address
    }
  }
}