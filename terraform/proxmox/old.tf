# resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
#   content_type = "iso"
#   datastore_id = "local"
#   node_name    = "pve"

#   url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
# }

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



