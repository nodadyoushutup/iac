resource "proxmox_virtual_environment_download_file" "talos_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "talos_cloud_image.img"
  url = "https://factory.talos.dev/image/d4cf8602b9d285ede53209d5e8c482372d61d3b9aa850736c2dc65bd8d091cba/v1.8.3/metal-amd64.qcow2"
}

