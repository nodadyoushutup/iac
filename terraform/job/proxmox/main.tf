module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = local.config
    name = "debug"
    # datastore_id = "local"
    # node_name = "pve"
    # username = "nodadyoushutup"
    address = "dhcp"
    # bios = "seabios"
    github = "nodadyoushutup"
}

output "debug" {
    value = module.cloud_config.debug
}