resource "proxmox_virtual_environment_vm" "test_vm" {
  depends_on = [ proxmox_virtual_environment_download_file.centos_9 ]
  stop_on_destroy = true
  disk {
    datastore_id = "local-lvm"
    file_id = proxmox_virtual_environment_download_file.centos_9.id
    interface = "scsi0"
    size = 32
  }
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = []
      password = "centos"
      username = "centos"
    }
  }
  node_name = "pve"
  agent {
    enabled = false
  }
}
