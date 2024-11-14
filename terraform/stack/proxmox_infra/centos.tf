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
