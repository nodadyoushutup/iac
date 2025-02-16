resource "proxmox_virtual_environment_pool" "operations_pool" {
    comment = "Managed by Terraform"
    pool_id = "operations-pool"
}