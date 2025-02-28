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
        address = "192.168.1.102"
    }
}

module "image" {
    source = "../../module/proxmox/image"

    config = local.config
    name = "docker"
    datastore_id = "config"
    # file_name = "xyz-image.img"
    # node_name = "pve"
    # url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    # overwrite = true
    # overwrite_unmanaged = true
}

module "virtual_machine" {
  source = "../../module/proxmox/virtual_machine"

  config = local.config
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