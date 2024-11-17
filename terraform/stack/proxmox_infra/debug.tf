resource "proxmox_virtual_environment_vm" "debug" {
    name      = "debug"
    node_name = "pve"
    vm_id = "1100"

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
        datastore_id = "virtualization"
        version = "v2.0"
    }

    disk {
        datastore_id = "virtualization"
        file_id      = "local:iso/ubuntu-jammy.img"
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
        mac_address = "0a:00:00:00:12:06"
    }
}