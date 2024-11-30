resource "proxmox_virtual_environment_vm" "development" {
    depends_on = [ proxmox_virtual_environment_download_file.cloud_image ]
    name      = "development"
    node_name = "pve"
    vm_id = "1101"

    agent {
        enabled = true
    }

    cpu {
        cores = 2
        type = "x86-64-v2-AES"
    }

    memory {
        dedicated = 4096
    }

    tpm_state {
        datastore_id = "virtualization"
        version = "v2.0"
    }

    disk {
        datastore_id = "virtualization"
        file_id      = proxmox_virtual_environment_download_file.cloud_image.id
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
        mac_address = "0a:00:00:00:11:01"
    }

}