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

    dynamic "cdrom" {
        for_each = var.cdrom != null ? [var.cdrom] : []
        content {
            enabled = cdrom.value.enabled
            file_id = cdrom.value.file_id
            interface = cdrom.value.interface
        }
    }

    dynamic "clone" {
        for_each = var.clone != null ? [var.clone] : []
        content {
            datastore_id = clone.value.datastore_id
            node_name = clone.value.node_name
            retries = clone.value.retries
            vm_id = clone.value.vm_id
            full = clone.value.full
        }
    }

    dynamic "cpu" {
        for_each = var.cpu != null ? [var.cpu] : []
        content {
            architecture = cpu.value.architecture
            cores = cpu.value.cores
            flags = cpu.value.flags
            hotplugged = cpu.value.hotplugged
            limit = cpu.value.limit
            numa = cpu.value.numa
            sockets = cpu.value.sockets
            type = cpu.value.type
            units = cpu.value.units
            affinity = cpu.value.affinity
        }
    }

    description = var.description

    dynamic "disk" {
        for_each = var.disk != null ? [var.disk] : []
        content {
            aio = disk.value.aio
            backup = disk.value.backup
            cache = disk.value.cache
            datastore_id = disk.value.datastore_id
            path_in_datastore = disk.value.path_in_datastore
            discard = disk.value.discard
            file_format = disk.value.file_format
            file_id = disk.value.file_id
            interface = disk.value.interface
            iothread = disk.value.iothread
            replicate = disk.value.replicate
            serial = disk.value.serial
            size = disk.value.size
            ssd = disk.value.ssd
            dynamic "speed" {
                for_each = disk.value.speed != null ? [disk.value.speed] : []
                content {
                    iops_read = speed.value.iops_read
                    iops_read_burstable = speed.value.iops_read_burstable
                    iops_write = speed.value.iops_write
                    iops_write_burstable = speed.value.iops_write_burstable
                    read = speed.value.read
                    read_burstable = speed.value.read_burstable
                    write = speed.value.write
                    write_burstable = speed.value.write_burstable
                }
            }
        }
    }

    dynamic "efi_disk" {
        for_each = var.efi_disk != null ? [var.efi_disk] : []
        content {
            datastore_id = efi_disk.value.datastore_id
            file_format = efi_disk.value.file_format
            type = efi_disk.value.type
            pre_enrolled_keys = efi_disk.value.pre_enrolled_keys
        }
    }

    dynamic "tpm_state" {
        for_each = var.tpm_state != null ? [var.tpm_state] : []
        content {
            datastore_id = tpm_state.value.datastore_id
            version = tpm_state.value.version
        }
    }

    dynamic "hostpci" {
        for_each = var.hostpci != null ? [var.hostpci] : []
        content {
            device = hostpci.value.device
            id = hostpci.value.id
            mapping = hostpci.value.mapping
            mdev = hostpci.value.mdev
            pcie = hostpci.value.pcie
            rombar = hostpci.value.rombar
            rom_file = hostpci.value.rom_file
            xvga = hostpci.value.xvga
        }
    }








































    name = var.name
    stop_on_destroy = var.stop_on_destroy
    vm_id = var.vm_id

    

    

    dynamic "memory" {
        for_each = var.memory != null ? [var.memory] : []
        content {
            dedicated = memory.value.dedicated
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

