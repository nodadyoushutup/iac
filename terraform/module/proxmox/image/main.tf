resource "proxmox_virtual_environment_download_file" "image" {
    content_type = "iso"
    datastore_id = local.datastore_id_computed
    file_name = local.file_name_computed
    node_name = local.node_name_computed
    url = local.url_computed
    overwrite = local.overwrite_computed
    overwrite_unmanaged = local.overwrite_unmanaged_computed
}



output "debug" {
    value = proxmox_virtual_environment_download_file.image.id
}
