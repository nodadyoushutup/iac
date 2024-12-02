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

    dynamic "usb" {
        for_each = var.usb != null ? [var.usb] : []
        content {
            host = usb.value.host
            mapping = usb.value.mapping
            usb3 = usb.value.usb3
        }
    }

    dynamic "initialization" {
        for_each = var.initialization != null ? [var.initialization] : []
        content {
            datastore_id          = initialization.value.datastore_id
            interface             = initialization.value.interface
            network_data_file_id  = initialization.value.network_data_file_id
            user_data_file_id     = initialization.value.user_data_file_id
            vendor_data_file_id   = initialization.value.vendor_data_file_id
            meta_data_file_id     = initialization.value.meta_data_file_id
            dynamic "dns" {
                for_each = initialization.value.dns != null ? [initialization.value.dns] : []
                content {
                    domain  = dns.value.domain
                    server  = dns.value.server
                    servers = dns.value.servers
                }
            }
            dynamic "ip_config" {
                for_each = initialization.value.ip_config != null ? [initialization.value.ip_config] : []
                content {
                    dynamic "ipv4" {
                        for_each = ip_config.value.ipv4 != null ? [ip_config.value.ipv4] : []
                        content {
                            address = ipv4.value.address
                            gateway = ipv4.value.gateway
                        }
                    }
                    dynamic "ipv6" {
                        for_each = ip_config.value.ipv6 != null ? [ip_config.value.ipv6] : []
                        content {
                            address = ipv6.value.address
                            gateway = ipv6.value.gateway
                        }
                    }
                }
            }
            dynamic "user_account" {
                for_each = initialization.value.user_account != null ? [initialization.value.user_account] : []
                content {
                    keys = user_account.value.keys
                    password = user_account.value.password
                    username = user_account.value.username
                }
            }
        }
    }

    keyboard_layout = var.keyboard_layout

    kvm_arguments = var.kvm_arguments

    machine = var.machine

    dynamic "memory" {
        for_each = var.memory != null ? [var.memory] : []
        content {
            dedicated = memory.value.dedicated
            floating = memory.value.floating
            shared = memory.value.shared
            hugepages = memory.value.hugepages
            keep_hugepages = memory.value.keep_hugepages
        }
    }

    # TODO: NUMA configuration

    migrate = var.migrate

    name = var.name

    dynamic "network_device" {
        for_each = var.network_device != null ? [var.network_device] : []
        content {
            bridge = network_device.value.bridge
            disconnected = network_device.value.disconnected
            enabled = network_device.value.enabled
            firewall = network_device.value.firewall
            mac_address = network_device.value.mac_address
            model = network_device.value.model
            mtu = network_device.value.mtu
            queues = network_device.value.queues
            rate_limit = network_device.value.rate_limit
            vlan_id = network_device.value.vlan_id
            trunks = network_device.value.trunks
        }
    }   

    on_boot = var.on_boot

    dynamic "operating_system" {
        for_each = var.operating_system != null ? [var.operating_system] : []
        content {
            type = operating_system.value.type
        }
    }

    pool_id = var.pool_id

    protection = var.protection

    reboot = var.reboot

    dynamic "serial_device" {
        for_each = var.serial_device != null ? [var.serial_device] : []
        content {
            device = serial_device.value.device
        }
    }

    scsi_hardware = var.scsi_hardware

    dynamic "smbios" {
        for_each = var.smbios != null ? [var.smbios] : []
        content {
            family = smbios.value.family
            manufacturer = smbios.value.manufacturer
            product = smbios.value.product
            serial = smbios.value.serial
            sku = smbios.value.sku
            uuid = smbios.value.uuid
            version = smbios.value.version
        }
    }

    started = var.started

    dynamic "startup" {
        for_each = var.startup != null ? [var.startup] : []
        content {
            order = startup.value.order
            up_delay = startup.value.up_delay
            down_delay = startup.value.down_delay
        }
    }

    tablet_device = var.tablet_device

    tags = var.tags

    template = var.template

    stop_on_destroy = var.stop_on_destroy

    timeout_clone = var.timeout_clone

    timeout_create = var.timeout_create

    timeout_migrate = var.timeout_migrate

    timeout_reboot = var.timeout_reboot

    timeout_shutdown_vm = var.timeout_shutdown_vm

    timeout_start_vm = var.timeout_start_vm

    timeout_stop_vm = var.timeout_stop_vm



    
    vm_id = var.vm_id
    

    

}

