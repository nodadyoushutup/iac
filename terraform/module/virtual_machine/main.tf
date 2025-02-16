# terraform/module/virtual_machine.tf

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }

  backend "s3" {
    key = "virtual_machine.tfstate"
  }
}

locals {
    pool_id = "debug"
}

resource "proxmox_virtual_environment_pool" "operations_pool" {
    comment = "Managed by Terraform"
    pool_id = local.pool_id
}