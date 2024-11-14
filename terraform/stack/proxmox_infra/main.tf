resource "proxmox_virtual_environment_vm" "test_vm" {
  stop_on_destroy = true
  node_name = "pve"
  agent {
    enabled = false
  }
}

