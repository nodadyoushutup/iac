module "cloud_init_user" {
    source = "../../module/proxmox/cloud_init_user"

    # PROXMOX
    config = local.config
    name = "test"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    
    # NETWORK
    network = {
        version = 2
        ethernets = {
            eth0 = {
                match = {
                    name = "en*"
                }
                type = "physical"
                set-name = "eth0"
                dhcp4 = "no"
                addresses = [
                    "192.168.1.185/24"
                ]
                gateway4 = "192.168.1.1"
                nameservers = {
                    addresses = [
                        "8.8.8.8",
                        "8.8.4.4"
                    ]
                }
            }
        }
    }

    # USER
    bootcmd = [
        "mkdir -p /mnt/epool/media"
    ]
    runcmd = [
        "echo 'runcmd test'"
    ]
    mounts = [
        ["192.168.1.100:/mnt/epool/media", "/mnt/epool/media", "nfs","defaults,_netdev", "0", "0"]
    ]
    users = [
        {
            name = "nodadyoushutup"
            groups = ["sudo", "docker"]
            ssh_import_id = ["gh:nodadyoushutup"]
            shell = "/bin/bash"
            sudo = "ALL=(ALL) NOPASSWD:ALL"
            plain_text_passwd = "password"
            lock_passwd = false,
        }
    ]
    groups = ["docker"]
    gitconfig = {
        username = "nodadyoushutup"
        email = "admin@nodadyoushutup.com"
        github_pat = local.config.proxmox.global.machine.cloud_config.gitconfig.github_pat
    }
    write_files = [
        {
            path = "/etc/skel/.canary"
            encoding = "b64"
            content = "Y2FuYXJ5Cg=="
            permissions = "0640"
        }
    ]
}


output "cloud_init_user" {
  value = module.cloud_init_user
}