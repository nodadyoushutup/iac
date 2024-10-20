resource "proxmox_virtual_environment_vm" "docker_vm" {
  name = "docker"
  description = "docker"
  tags = ["terraform", "ubuntu", "docker"]
  node_name = "pve"
  vm_id = 101
  agent {
    enabled = false
  }
  stop_on_destroy = true
  startup {
    order = "1"
  }
  cpu {
    cores = 4
    type = "x86-64-v2-AES"
  }
  memory {
    dedicated = 4096
  }
  disk {
    datastore_id = "local-lvm"
    file_id = "local:iso/jammy-server-cloudimg-amd64.img"
    interface = "scsi0"
  }
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.101/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      keys = try(local.config.virtual_machine.keys, [])
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

resource "proxmox_virtual_environment_vm" "development_vm" {
  name = "development"
  description = "development"
  tags = ["terraform", "ubuntu", "development"]
  node_name = "pve"
  vm_id = 102
  agent {
    enabled = false
  }
  stop_on_destroy = true
  startup {
    order = "1"
  }
  cpu {
    cores = 4
    type = "x86-64-v2-AES"
  }
  memory {
    dedicated = 4096
  }
  disk {
    datastore_id = "local-lvm"
    file_id = "local:iso/jammy-server-cloudimg-amd64.img"
    interface = "scsi0"
  }
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.102/24"
        gateway = "192.168.1.1"
      }
    }
    user_account {
      keys = try(local.config.virtual_machine.keys, [])
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
