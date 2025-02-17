locals {
  controlplane = [
    {
      name = "talos-cp-0"
      vm_id = 1200
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.200"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name = "talos-cp-1"
      vm_id = 1201
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.201"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name = "talos-cp-2"
      vm_id = 1202
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.202"
            gateway = "192.168.1.1"
          }
        }
      }
    }
  ]
  worker = [
    {
      name = "talos-wk-0"
      vm_id = 1200
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.203"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name = "talos-wk-1"
      vm_id = 1201
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.204"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name = "talos-wk-2"
      vm_id = 1202
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.205"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name = "talos-wk-3"
      vm_id = 1202
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.206"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name = "talos-wk-4"
      vm_id = 1202
      image = {
        url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
      }
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.207"
            gateway = "192.168.1.1"
          }
        }
      }
    }
  ]
}

module "talos_controlplane" {
  source = "../../module/proxmox/virtual_machine"

  # Turn the list into a map keyed by name
  for_each = { for machine in local.controlplane : machine.name => machine }

  image = each.value.image
  initialization = each.value.initialization
  name = each.value.name
  vm_id = each.value.vm_id
}

module "talos_worker" {
  source = "../../module/proxmox/virtual_machine"

  # Turn the list into a map keyed by name
  for_each = { for machine in local.worker : machine.name => machine }

  image = each.value.image
  initialization = each.value.initialization
  name = each.value.name
  vm_id = each.value.vm_id
}