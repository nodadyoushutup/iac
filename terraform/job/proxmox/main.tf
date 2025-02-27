module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = local.config
    name = "debug"
    # datastore_id = "local"
    # node_name = "pve"
    address = "dhcp"

    auth = {
        username = "nodadyoushutup"
        github = "nodadyoushutup"
    }
}


output "debug" {
    value = module.cloud_config
}