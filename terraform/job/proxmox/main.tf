

module "virtual_machine" {
    source = "../../module/proxmox/virtual_machine"

    config = local.config
    name = "docker"
}

# output "cloud_config" {
#     value = module.cloud_config
# }

# output "image" {
#     value = module.image
# }

output "virtual_machine" {
    value = module.virtual_machine
}