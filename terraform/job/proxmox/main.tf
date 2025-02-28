module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = local.config
    name = "debug"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    auth = {
        username = "nodadyoushutup"
        github = "nodadyoushutup"
    }
    ipv4 = {
        address = "dhcp"
    }
}


output "debug" {
    value = module.cloud_config
}