# modules/proxmox/virtual_machine/main.tf

resource "proxmox_virtual_environment_vm" "virtual_machine" {
  vm_id = var.vm_id
  name = var.name
  description = var.description
  tags = var.tags
  node_name = var.node_name
  on_boot = var.on_boot
  started = var.started
  stop_on_destroy = var.stop_on_destroy
  boot_order = var.boot_order
  agent {
    enabled = false
  }
  disk {
    datastore_id = var.disk.datastore_id
    file_id = var.disk.file_id
    interface = var.disk.interface
    size = var.disk.size
  }
  memory {
    dedicated = var.memory.dedicated
  }
  cpu {
    sockets = var.cpu.sockets
    cores = var.cpu.cores
  }
  initialization {
    ip_config {
      ipv4 {
        address = lookup(var.initialization.ip_config.ipv4, "address", "dhcp")
        gateway = lookup(var.initialization.ip_config.ipv4, "gateway", null)
      }
      ipv6 {
        address = lookup(var.initialization.ip_config.ipv6, "address", "dhcp")
        gateway = lookup(var.initialization.ip_config.ipv6, "gateway", null)
      }
    }
    user_account {
      username = lookup(local.virtual_machine, "username", try(var.initialization.user_account.username, "ubuntu"))
      password = lookup(local.virtual_machine, "password", try(var.initialization.user_account.password, "ubuntu"))
      keys = lookup(local.virtual_machine, "keys", try(var.initialization.user_account.keys, []))
    }
  }
  network_device {
    bridge = var.network_device.bridge
    model = var.network_device.model
  }
}
