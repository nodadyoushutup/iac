resource "proxmox_virtual_environment_download_file" "cloud_default" {
    content_type = "iso"
    datastore_id = "local"
    file_name = "default-cloud-image-x86-64.img"
    node_name = var.terraform.proxmox.ssh.node.name
    url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
}