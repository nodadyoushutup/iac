module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = var.config
    name = "test"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    auth = {
        username = "nodadyoushutup"
        password = "password"
    }
    github = {
        username = "nodadyoushutup"
        email = "admin@nodadyoushutup.com"
    }
    mounts = [
        ["192.168.1.100:/mnt/epool/media", "/media", "nfs","defaults,_netdev", "0", "0"]
    ]
    ipv4 = {
        address = "192.168.1.185"
    }

    users = [
        {
            name = "nodadyoushutup"
            groups = "sudo"
            ssh_import_id = ["gh:nodadyoushutup"]
            shell = "/bin/bash"
            sudo = "ALL=(ALL) NOPASSWD:ALL"
        }
    ]
}


output "cloud_config" {
  value = module.cloud_config
}