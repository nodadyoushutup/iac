module "debug_vm_test" {
  source = "../../module/proxmox/virtual_machine"
  depends_on = [
    proxmox_virtual_environment_download_file.cloud,
    proxmox_virtual_environment_file.cloud_config
  ]

  image = {
    file_name = "nocloud-amd64.img"
    # url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    url = "https://github.com/nodadyoushutup/iac/releases/download/v1.9.4/nocloud-amd64.raw"
  }

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