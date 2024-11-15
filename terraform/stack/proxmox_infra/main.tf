# data "local_file" "ssh_public_key" {
#   filename = "./id_rsa.pub"
# }

# variable "mounts" {
#   type = list(list(string))
#   default = [["192.168.1.100:/mnt/epool/media", "/mnt/epool/media", "nfs", "defaults", "0", "0"]]
# }

# resource "proxmox_virtual_environment_file" "cloud_config" {
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = "pve"

#   source_raw {
#     data = <<-EOF
#     #cloud-config
#     users:
#       - default
#       - name: ubuntu
#         groups:
#           - sudo
#         shell: /bin/bash
#         ssh_authorized_keys:
#           - ${trimspace(data.local_file.ssh_public_key.content)}
#         sudo: ALL=(ALL) NOPASSWD:ALL
#     mounts: ${jsonencode(var.mounts)}
#     write_files:
#       - path: /tmp/.gitconfig
#         owner: ubuntu:ubuntu
#         permissions: '0644'
#         content: |
#           [user]
#             name = nodadyoushutup
#             email = admin@nodadyoushutup.com
#     runcmd:
#         - apt update
#         - apt install -y qemu-guest-agent net-tools python3 python3-pip nfs-common zip curl
#         - apt install -y curl postgresql-client mysql-client-core-8.0 git whois jq nmap
#         - systemctl enable qemu-guest-agent
#         - systemctl start qemu-guest-agent
#         - mkdir -p $(echo ${join(" ", [for mount in var.mounts : mount[1]])})
#         - mount -a
#         - mv /tmp/.gitconfig /home/ubuntu
#         - chown ubuntu:ubuntu /home/ubuntu/.gitconfig
#         - echo "done" > /tmp/cloud-config.done
#     EOF

#     file_name = "cloud-config.yaml"
#   }
# }

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "talos-cp-0"
  node_name = "pve"

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  tpm_state {
    datastore_id = "local-lvm"
    version = "v2.0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_cloud_image.id
    interface    = "scsi0"
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_download_file" "talos_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "talos_cloud_image.img"
  url = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.8.3/metal-amd64.qcow2"
}


output "vm_ipv4_address" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses
}