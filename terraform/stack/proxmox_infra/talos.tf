resource "proxmox_virtual_environment_download_file" "talos_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  file_name = "talos_cloud_image.img"
  url = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.8.3/metal-amd64.qcow2"
}

resource "proxmox_virtual_environment_vm" "talos_cp_0" {
    depends_on = [ proxmox_virtual_environment_download_file.talos_cloud_image ]
    name      = "talos-cp-0"
    node_name = "pve"
    vm_id = "200"

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
        mac_address = "0a:00:00:00:02:00"
    }

}

resource "proxmox_virtual_environment_vm" "talos_cp_1" {
    name      = "talos-cp-1"
    node_name = "pve"
    vm_id = "201"

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
        mac_address = "0a:00:00:00:02:01"
    }
}

resource "proxmox_virtual_environment_vm" "talos_cp_2" {
    name      = "talos-cp-2"
    node_name = "pve"
    vm_id = "202"

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
        mac_address = "0a:00:00:00:02:02"
    }
}