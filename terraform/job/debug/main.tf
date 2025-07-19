module "cloud_config" {
    source = "../../module/proxmox/cloud_config"

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
    mounts = [
        ["192.168.1.100:/mnt/epool/media", "/media", "nfs","defaults,_netdev", "0", "0"]
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
        },
        {
            name = "test"
            groups = ["sudo", "docker"]
            ssh_import_id = ["gh:nodadyoushutup"]
            shell = "/bin/bash"
            sudo = "ALL=(ALL) NOPASSWD:ALL"
            plain_text_passwd = "password"
            lock_passwd = false,
        }
    ]
    # groups can be provided as a simple list
    groups = ["docker"]
    gitconfig = {
        username = "nodadyoushutup"
        email = "admin@nodadyoushutup.com"
        github_pat = local.config.proxmox.global.machine.cloud_config.gitconfig.github_pat
    }
    write_files = [
        {
            path = "/etc/skel/hello.txt"
            encoding = "b64"
            content = "aGVsbG8gd29ybGQK"
            owner = "nodadyoushutup:nodadyoushutup"
            permissions = "0640"
            defer = true
        }
    ]
    bootcmd = [
        "echo 'bootcmd test'"
    ]
    runcmd = [
        "echo 'runcmd test'"
    ]
}


output "cloud_config" {
  value = module.cloud_config
}

output "config" {
  value = local.config.proxmox.global.machine.cloud_config.gitconfig.github_pat
}