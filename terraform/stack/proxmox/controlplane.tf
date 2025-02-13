locals {
    talos = {
        controlplane = [
            {
                ip_address = "192.168.1.200"
                mac_address = "00:11:22:33:44:55"
                vm_id = "1200"
            },
            {
                ip_address = "192.168.1.201"
                mac_address = "00:11:22:33:44:66"
                vm_id = "1201"
            },
            {
                ip_address = "192.168.1.202"
                mac_address = "00:11:22:33:44:77"
                vm_id = "1202"
            },
        ]
        worker = [
            {
                ip_address = "192.168.1.203"
                mac_address = "00:11:22:33:44:88"
                vm_id = "1203"
            }
        ]
    }
}

resource "proxmox_virtual_environment_vm" "talos_cp" {
    for_each = { for cp in local.talos.controlplane : cp.ip_address => cp }

    depends_on = [
        proxmox_virtual_environment_file.cloud_config
    ]
    
    node_name = var.PROXMOX_VE_SSH_NODE_NAME

    agent {
        enabled = true
        timeout = "5m"
        trim    = false
        type    = "virtio"
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

    description = "talos-cp-${each.key}"

    disk {
        aio           = "io_uring"
        backup        = true
        cache         = "none"
        datastore_id  = var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_DISK
        discard       = "on"
        file_format   = "raw"
        file_id       = "${var.VIRTUAL_MACHINE_GLOBAL_DATASTORE_ID_ISO}:iso/talos-cp-${each.key}-v1.9.3-metal-amd64.img"
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

    name = "talos-cp-${each.key}"

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