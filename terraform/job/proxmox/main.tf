# module "cloud_config" {
#     source = "../../module/proxmox/cloud_config"

#     config = local.config
#     name = "debug"
#     datastore_id = "config"
#     node_name = "pve"
#     overwrite = true
#     auth = {
#         username = "nodadyoushutup"
#         github = "nodadyoushutup"
#     }
#     ipv4 = {
#         address = "192.168.1.102"
#     }
# }

module "image" {
    source = "../../module/proxmox/image"

    config = local.config
}



output "debug" {
    value = module.image
}