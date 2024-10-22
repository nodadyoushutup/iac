resource "proxmox_virtual_environment_file" "docker_cloud_config" {
  content_type = "snippets"
  datastore_id = try(local.config.virtual_machine.datastore_id.cloud_config)
  node_name    = try(local.config.provider.proxmox.ssh.node.name)
  source_raw {
    data = local.cloud_config
    file_name = "docker-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "docker_vm" {
  depends_on = [proxmox_virtual_environment_file.docker_cloud_config]
  name = "docker"
  description = "docker"
  tags = ["terraform", "ubuntu", "docker"]
  node_name = try(local.config.provider.proxmox.ssh.node.name)
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
    datastore_id = try(local.config.virtual_machine.datastore_id.disk)
    file_id = try(concat([local.config.virtual_machine.datastore_id.iso, ":", local.config.virtual_machine.file_id]))
    interface = "scsi0"
  }
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.101/24"
        gateway = "192.168.1.1"
      }
    }
    # user_account {
    #   keys = try(local.config.virtual_machine.keys, [])
    #   password = try(local.config.virtual_machine.password, "ubuntu")
    #   username = try(local.config.virtual_machine.username, "ubuntu")
    # }
    user_data_file_id = proxmox_virtual_environment_file.docker_cloud_config.id
  }
  network_device {
    bridge = "vmbr0"
  }
  operating_system {
    type = "l26"
  }
}

