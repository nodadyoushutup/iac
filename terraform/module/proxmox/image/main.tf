resource "proxmox_virtual_environment_download_file" "image" {
    content_type = "iso"
    datastore_id = "local"
    file_name = "cloud-image.img"
    node_name = "pve"
    url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    checksum = "58fafa456675eabcb995b5bca12af4edf96959966d0086c4979c5107f3fe11c3"
    checksum_algorithm = "sha256"
}



output "debug" {
    value = proxmox_virtual_environment_download_file.image.id
}
