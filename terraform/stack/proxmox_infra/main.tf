resource "proxmox_virtual_environment_download_file" "ubuntu_bionic_18_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_focal_20_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_jammy_22_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_noble_22_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "centos_8_4" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "CentOS-8-GenericCloud-8.4.img"
  url = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "test_vm" {
  stop_on_destroy = true
  disk {
    datastore_id = "local-lvm"
    file_id = proxmox_virtual_environment_download_file.centos_8_4.id
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
