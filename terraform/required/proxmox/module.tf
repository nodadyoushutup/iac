module "debug_vm_test" {
  source = "../../module/proxmox/virtual_machine"
  depends_on = [
    proxmox_virtual_environment_download_file.cloud,
    proxmox_virtual_environment_file.cloud_config
  ]

  cloud_config = {
    hostname = "test"
    auth = {
      github = "nodadyoushutup"
      username = "nodadyoushutup"
    }
    runcmd = [
      "touch /tmp/runcmd"
    ]
  }

  initialization = {
    ip_config = {
      ipv4 = {
        address = "192.168.1.190"
        gateway = "192.168.1.1"
      }
    }
  }

  name = "test"
  
  vm_id = 190
}