resource "proxmox_virtual_environment_vm" "virtual_machine" {
    depends_on = [ proxmox_virtual_environment_download_file.cloud_image ]
    name      = "vm"
    node_name = "pve"
    vm_id = "1103"

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
        size         = 100
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
        mac_address = "0a:00:00:00:11:02"
    }

}

resource "spacelift_context_attachment" "config_virtual_machine" {
    context_id = "config"
    module_id   = "virtual_machine"
    priority   = 0
}