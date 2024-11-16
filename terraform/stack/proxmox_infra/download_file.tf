# TALOS
resource "proxmox_virtual_environment_download_file" "talos_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "talos_cloud_image.img"
  url = "https://factory.talos.dev/image/d4cf8602b9d285ede53209d5e8c482372d61d3b9aa850736c2dc65bd8d091cba/v1.8.3/metal-amd64.qcow2"
}

# UBUNTU
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

# CENTOS
resource "proxmox_virtual_environment_download_file" "centos_6" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "CentOS_6.img"
  url = "https://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud.qcow2"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "centos_7" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "CentOS_7.img"
  url = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "centos_8" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "CentOS_8.img"
  url = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_download_file" "centos_9" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "CentOS_9.img"
  url = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20241112.0.x86_64.qcow2"
  overwrite_unmanaged = true
}
