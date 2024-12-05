resource "proxmox_virtual_environment_download_file" "cloud_image" {
    content_type = "iso"
    datastore_id = "local"
    node_name    = "pve"
    url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.1/cloud_image_x86_64_jammy.img"
}