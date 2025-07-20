module "virtual_machine" {
  source = "../../module/proxmox/virtual_machine"

  config = local.config
  vm_id  = 2000

  cloud_init = {
    config       = local.config
    name         = "test"
    datastore_id = "config"
    node_name    = "pve"
    overwrite    = true

    network = {
      ethernets = {
        eth0 = {
          match = {
            name = "en*"
          }
          set-name  = "eth0"
          dhcp4     = false
          addresses = ["192.168.1.150/24"]
          gateway4  = "192.168.1.1"
          nameservers = {
            addresses = ["8.8.8.8", "8.8.4.4"]
          }
        }
      }
    }

    bootcmd = ["mkdir -p /mnt/epool/media"]
    runcmd  = ["echo 'runcmd test'"]
    mounts  = [["192.168.1.100:/mnt/epool/media", "/mnt/epool/media", "nfs", "defaults,_netdev", "0", "0"]]
    users = [{
      name              = "nodadyoushutup"
      groups            = ["sudo", "docker"]
      ssh_import_id     = ["gh:nodadyoushutup"]
      shell             = "/bin/bash"
      sudo              = "ALL=(ALL) NOPASSWD:ALL"
      plain_text_passwd = "password"
      lock_passwd       = false
    }]
    groups = ["docker"]
    gitconfig = {
      username   = "nodadyoushutup"
      email      = "admin@nodadyoushutup.com"
      github_pat = local.config.proxmox.global.machine.cloud_config.gitconfig.github_pat
    }
    write_files = [{
      path        = "/etc/skel/.canary"
      encoding    = "b64"
      content     = "Y2FuYXJ5Cg=="
      permissions = "0640"
    }]
  }
}

output "virtual_machine" {
  value = module.virtual_machine.debug
}
