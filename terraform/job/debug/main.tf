module "cloud_init" {
    source = "../../module/proxmox/cloud_init"

    # PROXMOX
    config       = local.config
    name         = "test"
    datastore_id = "config"
    node_name    = "pve"
    overwrite    = true

    # NETWORK
    network = {
      ethernets = {
        eth0 = {
          match = {
            name = "en*"
          }
          set-name = "eth0"
          dhcp4 = false
          addresses = ["192.168.1.150/24"]
          gateway4 = "192.168.1.1"
          nameservers = {
            addresses = ["8.8.8.8", "8.8.4.4"]
          }
        }
      }
    }
}

output "cloud_init" {
  value = module.cloud_init
}
