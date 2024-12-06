# resource "proxmox_virtual_environment_download_file" "cloud_image" {
#     content_type = "iso"
#     datastore_id = "local"
#     node_name    = "pve"
#     url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.1/cloud_image_x86_64_jammy.img"
# }

# resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
#   node_name = "pve"

#   agent {
#     enabled = false
#   }
#   stop_on_destroy = true

#   cpu {
#     cores        = 2
#     type         = "x86-64-v2-AES"
#   }

#   memory {
#     dedicated = 2048
#     floating  = 0
#   }

#   disk {
#     datastore_id = "local-lvm"
#     file_id      = "local:iso/cloud_image_x86_64_jammy.img"
#     interface    = "scsi0"
#   }

#   network_device {
#     bridge = "vmbr0"
#   }

#   operating_system {
#     type = "l26"
#   }
# }