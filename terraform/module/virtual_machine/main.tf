# terraform/module/virtual_machine.tf

locals {
    pool_id = "debug"
}

resource "proxmox_virtual_environment_pool" "operations_pool" {
    comment = "Managed by Terraform"
    pool_id = local.pool_id
}