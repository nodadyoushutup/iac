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
        password = "password"
    }
    ipv4 = {
        address = "192.168.1.185"
    }
}

output "cloud_config" {
  value = module.cloud_config
}