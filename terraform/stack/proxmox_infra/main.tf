resource "proxmox_virtual_environment_vm" "test_vm" {
  stop_on_destroy = true
  agent {
    enabled = false
  }
}

