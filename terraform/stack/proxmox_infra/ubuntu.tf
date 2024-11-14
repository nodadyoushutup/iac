resource "proxmox_virtual_environment_download_file" "ubuntu_18_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "ubuntu_18_04.img"
  url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_20_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "ubuntu_20_04.img"
  url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_22_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "ubuntu_22_04.img"
  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "ubuntu_24_04" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "ubuntu_24_04.img"
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}
