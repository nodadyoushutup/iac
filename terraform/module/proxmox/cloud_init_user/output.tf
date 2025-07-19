# output "name" {
#     value = local.name
# }

# output "node_name" {
#     value = local.node_name_computed
# }

# output "overwrite" {
#     value = local.overwrite_computed
# }

# output "type" {
#     value = local.type
# }

output "template" {
    value = local.template
}

output "pve_snippet" {
    value = proxmox_virtual_environment_file.user
}