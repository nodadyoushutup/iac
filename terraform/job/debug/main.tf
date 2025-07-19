module "cloud_init" {
    source = "../../module/proxmox/cloud_init_network"

    # PROXMOX
    config = local.config
    name = "test"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true

    # NETWORK
    
}


output "cloud_init" {
  value = module.cloud_init
}