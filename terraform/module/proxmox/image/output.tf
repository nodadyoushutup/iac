output "name" {
    value = local.name
}

output "datastore_id" {
    value = local.datastore_id_computed
}

output "file_name" {
    value = local.file_name
}

output "node_name" {
    value = local.node_name_computed
}

output "url" {
    value = local.url_computed
}

output "overwrite" {
    value = local.overwrite_computed
}

output "overwrite_unmanaged" {
    value = local.overwrite_unmanaged_computed
}

output "image_id" {
    value = proxmox_virtual_environment_download_file.image.id
}