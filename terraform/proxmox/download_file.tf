# CLOUD IMAGE
resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "iso"
  datastore_id = local.config.data.proxmox.datastore.iso
  node_name    = local.config.data.proxmox.ssh.node.name
  url = "https://github.com/nodadyoushutup/cloud-image/releases/download/${local.config.data.proxmox.cloud_image_version}/cloud_image_x86_64_jammy.img"
}

# # TALOS
# resource "proxmox_virtual_environment_download_file" "talos_cloud_image" {
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = "pve"
#   file_name = "talos_cloud_image.img"
#   url = "https://factory.talos.dev/image/d4cf8602b9d285ede53209d5e8c482372d61d3b9aa850736c2dc65bd8d091cba/v1.8.3/metal-amd64.qcow2"
# }