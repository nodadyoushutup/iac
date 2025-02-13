locals {
    talos = {
        global = {
            agent = {
                enabled = true
                timeout = "5m"
                trim = false
                type = "virtio"
            }
        }
        controlplane = [
            {
                ip_address = "192.168.1.200"
                mac_address = "0a:00:00:00:12:00"
                vm_id = "1200"
            },
            {
                ip_address = "192.168.1.201"
                mac_address = "0a:00:00:00:12:01"
                vm_id = "1201"
            },
            {
                ip_address = "192.168.1.202"
                mac_address = "0a:00:00:00:12:02"
                vm_id = "1202"
            },
        ]
        worker = [
            {
                ip_address = "192.168.1.203"
                mac_address = "0a:00:00:00:12:03"
                vm_id = "1203"
            }
        ]
    }
}

resource "proxmox_virtual_environment_vm" "talos_cp" {
    for_each = { for idx, cp in local.talos.controlplane : idx => cp }

    depends_on = [
        proxmox_virtual_environment_download_file.talos_image,
        proxmox_virtual_environment_file.cloud_config
    ]
    node_name = var.PROXMOX_VE_SSH_NODE_NAME

    agent {
        enabled = true
        timeout = "5m"
        trim = false
        type = "virtio"
    }

    audio_device {
        device  = "intel-hda"
        driver  = "spice"
        enabled = true
    }

    bios       = "seabios"
    boot_order = ["scsi0"]

    cpu {
        cores      = 4
        flags      = ["+aes"]
        hotplugged = 0
        limit      = 0
        numa       = false
        sockets    = 1
        type       = "x86-64-v2-AES"
        units      = 1024
        affinity   = null
    }

    description = format("talos-cp-%d", each.key)

    disk {
        aio           = "io_uring"
        backup        = true
        cache         = "none"
        datastore_id  = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        discard       = "on"
        file_format   = "raw"
        file_id       = proxmox_virtual_environment_download_file.talos_image.id
        interface     = "scsi0"
        iothread      = false
        replicate     = true
        serial        = null
        size          = 100
        ssd           = true
    }

    machine = "q35"

    memory {
        dedicated = 4096
        floating  = 0
        shared    = 0
    }

    name = format("talos-cp-%d", each.key)

    network_device {
        bridge      = "vmbr0"
        disconnected = false
        enabled     = true
        firewall    = false
        mac_address = each.value.mac_address
        model       = "virtio"
    }

    on_boot = true

    operating_system {
        type = "l26"
    }

    started = true

    startup {
        order    = 2
        up_delay = 0
        down_delay = 0
    }

    tags = ["gitops", "talos-controlplane"]

    stop_on_destroy = true

    vga {
        memory    = 16
        type      = "qxl"
        clipboard = "vnc"
    }

    vm_id = tonumber(each.value.vm_id)
}