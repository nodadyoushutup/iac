module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = local.config
    name = "debug"
    # datastore_id = "local"
    # node_name = "pve"
    address = "192.168.1.102"

    auth = {
        username = "nodadyoushutup"
        github = "nodadyoushutup"
    }
}


output "debug" {
    value = module.cloud_config
}