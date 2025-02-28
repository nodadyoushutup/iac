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

resource "proxmox_virtual_environment_vm" "virtual_machine" {
    initialization {
        user_data_file_id = module.cloud_config.cloud_id
        network_data_file_id = module.cloud_config.network_id
    }

    disk {
        file_id = module.image.image_id
        size = 30
    }
    vm_id = 3000
    name = "test"
}