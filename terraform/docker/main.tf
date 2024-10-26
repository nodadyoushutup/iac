resource "proxmox_virtual_environment_vm" "docker_vm" {
  name = "docker"
  vm_id = 101
  description = "Docker applications"
  tags = ["terraform", "ubuntu", "docker"]
  node_name = try(local.config.spacelift.provider.proxmox.ssh.node.name)
  agent {
    enabled = false
  }
  stop_on_destroy = true
  startup {
    order = 1
    up_delay = 0
    down_delay = 0
  }
  cpu {
    cores = 4
    type = "x86-64-v2-AES"
  }
  memory {
    dedicated = 4096
  }
  disk {
    datastore_id = try(local.config.virtual_machine.datastore_id.disk)
    file_id = "${local.config.virtual_machine.datastore_id.iso}:iso/${local.config.virtual_machine.file_id}"
    interface = "scsi0"
    size = 100
  }
  initialization {
    ip_config {
      ipv4 {
        address = try(local.config.virtual_machine.docker.address)
        gateway = try(local.config.virtual_machine.docker.gateway)
      }
    }
    user_account {
      keys     = try(local.config.virtual_machine.keys, [])
      password = try(local.config.virtual_machine.password, "ubuntu")
      username = try(local.config.virtual_machine.username, "ubuntu")
    }
  }
  network_device {
    bridge = "vmbr0"
  }
  operating_system {
    type = "l26"
  }
}

