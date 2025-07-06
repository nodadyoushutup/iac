module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

    config = local.config
    name = "test"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    
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
            plain_text_passwd = "password"
            lock_passwd = false,
        },
        {
            name = "test"
            groups = "sudo"
            ssh_import_id = ["gh:nodadyoushutup"]
            shell = "/bin/bash"
            sudo = "ALL=(ALL) NOPASSWD:ALL"
            plain_text_passwd = "password"
            lock_passwd:false,
        }
    ]

    gitconfig = {
        username = "nodadyoushutup"
        email = "admin@nodadyoushutup.com"
        github_pat = local.config.proxmox.global.machine.cloud_config.gitconfig.github_pat
    }
}


output "cloud_config" {
  value = module.cloud_config
}

output "config" {
  value = local.config.proxmox.global.machine.cloud_config.gitconfig.github_pat
}