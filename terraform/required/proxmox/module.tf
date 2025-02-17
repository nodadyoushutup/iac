locals {
  machines = [
    {
      name           = "talos-cp-0"
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.190"
            gateway = "192.168.1.1"
          }
        }
      }
    },
    {
      name           = "talos-cp-1"
      initialization = {
        ip_config = {
          ipv4 = {
            address = "192.168.1.191"
            gateway = "192.168.1.1"
          }
        }
      }
    }
  ]
}

module "debug_vm_test" {
  source = "../../module/proxmox/virtual_machine"

  # Turn the list into a map keyed by name
  for_each = { for machine in local.machines : machine.name => machine }

  # Example image configuration
  image = {
    # url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    url = "https://github.com/nodadyoushutup/iac/releases/download/talos-0.1.3/talos-image-amd64-0.1.3.img"
  }

  # Example cloud-config
  cloud_config = {
    auth = {
      github   = "nodadyoushutup"
      username = "nodadyoushutup"
    }
  }

  # Pull in initialization (IP, gateway, etc.) from each machine
  initialization = each.value.initialization

  # Give each VM its `name`
  name = each.value.name
}
