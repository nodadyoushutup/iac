module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = local.config
    name = "talos-cp-2"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    auth = {
        username = "nodadyoushutup"
        github = "nodadyoushutup"
    }
    ipv4 = {
        address = "192.168.1.102"
    }
}

output "cloud_config" {
  value = module.cloud_config
}