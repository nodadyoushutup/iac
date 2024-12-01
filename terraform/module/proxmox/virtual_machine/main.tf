resource "proxmox_virtual_environment_vm" "virtual_machine" {
    # REQUIRED
    node_name = var.node_name

    # OPTIONAL
    acpi = var.acpi

    dynamic "agent" {
        for_each = var.agent != null ? [var.agent] : []
        content {
            enabled = agent.value.enabled
            timeout = agent.value.timeout
            trim = agent.value.trim
            type = agent.value.type
        }
    }
    
    dynamic "audio_device" {
        for_each = var.audio_device != null ? [var.audio_device] : []
        content {
            device = audio_device.value.device
            driver = audio_device.value.driver
            enabled = audio_device.value.enabled
        }
    }

    bios = var.bios

    boot_order = var.boot_order




















    name = var.name
    stop_on_destroy = var.stop_on_destroy
    vm_id = var.vm_id

    

    dynamic "cpu" {
        for_each = var.cpu != null ? [var.cpu] : []
        content {
            cores = cpu.value.cores
            type = cpu.value.type
        }
    }

    dynamic "memory" {
        for_each = var.memory != null ? [var.memory] : []
        content {
            dedicated = memory.value.dedicated
        }
    }

    dynamic "disk" {
        for_each = var.disk != null ? [var.disk] : []
        content {
            datastore_id = disk.value.datastore_id
            file_id = disk.value.file_id
            interface = disk.value.interface
            discard = disk.value.discard
            size = disk.value.size
        }
    }

    dynamic "network_device" {
        for_each = var.network_device != null ? [var.network_device] : []
        content {
            bridge = network_device.value.bridge
            mac_address = network_device.value.mac_address
        }
    }

    initialization {
        ip_config {
            ipv4 {
                address = "dhcp"
            }
            ipv6 {
                address = "dhcp"
            }
        }
    }

    

}

