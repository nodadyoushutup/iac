resource "proxmox_virtual_environment_vm" "virtual_machine" {
    # REQUIRED
    node_name = local.config.proxmox.ssh.node.name

    # OPTIONAL

    name = var.name
    # vm_id = "1103"
    # agent {
    #     enabled = true
    # }
    # cpu {
    #     cores = 2
    #     type = "x86-64-v2-AES"
    # }

    # memory {
    #     dedicated = 4096
    # }

    # tpm_state {
    #     datastore_id = "virtualization"
    #     version = "v2.0"
    # }

    # disk {
    #     datastore_id = "virtualization"
    #     file_id      = "local:iso/cloud_image_x86_64_jammy.img"
    #     interface    = "scsi0"
    #     discard      = "on"
    #     size         = 100
    # }

    # initialization {
    #     ip_config {
    #         ipv4 {
    #             address = "dhcp"
    #         }
    #         ipv6 {
    #             address = "dhcp"
    #         }
    #     }
    # }

    # network_device {
    #     bridge = "vmbr0"
    #     mac_address = "0a:00:00:00:11:02"
    # }

}

