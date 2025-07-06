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

output "cloud_id" {
    value = proxmox_virtual_environment_file.cloud.id
}

output "network_id" {
    value = proxmox_virtual_environment_file.network.id
}


# ######################
output "users" {
    sensitive = true
    value = local.users_computed
}

output "gitconfig" {
    sensitive = true
    value = local.gitconfig_computed
}

output "groups" {
    sensitive = true
    value = local.groups_computed
}
