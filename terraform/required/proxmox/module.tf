module "debug_vm_test" {
  source = "../../module/proxmox/virtual_machine"

  image = {
    file_name = "test.img"
    # url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
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

  name = "talos-cp-0"
  
  vm_id = 190
}