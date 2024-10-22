resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOF
    #cloud-config
    users:
      - default
      - name: ubuntu
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys: []
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
        - apt update
        - apt install -y qemu-guest-agent net-tools
        - timedatectl set-timezone America/Toronto
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}


resource "proxmox_virtual_environment_vm" "docker_vm" {
  depends_on = [proxmox_virtual_environment_file.cloud_config]
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
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }
  network_device {
    bridge = "vmbr0"
  }
  operating_system {
    type = "l26"
  }
}

