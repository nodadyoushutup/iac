output "name" {
    value = local.name
}

output "node_name" {
    value = local.node_name_computed
}

output "overwrite" {
    value = local.overwrite_computed
}

output "type" {
    value = local.type
}

output "template" {
    value = local.template
}

output "auth" {
    sensitive = true
    value = local.auth_computed
}

output "ipv4" {
    value = local.ipv4_computed
}

output "cloud_id" {
    value = proxmox_virtual_environment_file.cloud.id
}

output "network_id" {
    value = proxmox_virtual_environment_file.network.id
}