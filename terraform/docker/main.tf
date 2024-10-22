resource "proxmox_virtual_environment_file" "docker_cloud_config" {
  content_type = "snippets"
  datastore_id = try(local.config.virtual_machine.datastore_id.cloud_config)
  node_name    = try(local.config.provider.proxmox.ssh.node.name)
  source_raw {
    data = <<-EOF
    #cloud-config
        users:
          - default
          - name: ubuntu
            passwd: $6$rounds=4096$T8DMtimvQVZEyTGr$I3wHi8.0NxA938poCUOqtqcJQbAt335MfHF.lpS8Fdwfnt45vH5goXxPQ.RXBGef2yegKPero/PFYvKOmJWeS1
            groups:
              - sudo
            shell: /bin/bash
            ssh_authorized_keys: []
            sudo: ALL=(ALL) NOPASSWD:ALL
    EOF
    file_name = "docker-cloud-config.yaml"
  }
}

output "cloud_config" {
  value = local.cloud_config
}

resource "proxmox_virtual_environment_vm" "docker_vm" {
  depends_on = [proxmox_virtual_environment_file.docker_cloud_config]
  name = "docker"
  vm_id = 101
  description = "docker"
  tags = ["terraform", "ubuntu", "docker"]
  node_name = try(local.config.provider.proxmox.ssh.node.name)
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
    user_data_file_id = proxmox_virtual_environment_file.docker_cloud_config.id
  }
  network_device {
    bridge = "vmbr0"
  }
  operating_system {
    type = "l26"
  }
}

