module "cloud_config" {
    source = "../cloud_config"

    config = var.config
    name = "docker"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    auth = {
        username = "nodadyoushutup"
        github = "nodadyoushutup"
    }
    ipv4 = {
        address = "192.168.1.102"
    }
}

module "image" {
    source = "../image"

    config = var.config
    name = "docker"
    datastore_id = "config"
    # file_name = "xyz-image.img"
    # node_name = "pve"
    # url = "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    # overwrite = true
    # overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "virtual_machine" {
    depends_on = [ 
        module.cloud_config,
        module.image
    ]

    agent {
        enabled = local.virtual_machine.agent_computed.enabled
        timeout = local.virtual_machine.agent_computed.timeout
        trim = local.virtual_machine.agent_computed.trim
        type = local.virtual_machine.agent_computed.type
    }

    audio_device {
        device = local.virtual_machine.audio_device_computed.device
        driver = local.virtual_machine.audio_device_computed.driver
        enabled = local.virtual_machine.audio_device_computed.enabled
    }

    # bios = local.virtual_machine.bios_computed
    bios = "seabios"

    boot_order = local.virtual_machine.boot_order_computed

    cpu {
        affinity = local.virtual_machine.cpu_computed.affinity
        cores = local.virtual_machine.cpu_computed.cores
        flags = local.virtual_machine.cpu_computed.flags
        hotplugged = local.virtual_machine.cpu_computed.hotplugged
        limit = local.virtual_machine.cpu_computed.limit
        numa = local.virtual_machine.cpu_computed.numa
        sockets = local.virtual_machine.cpu_computed.sockets
        type = local.virtual_machine.cpu_computed.type
        units = local.virtual_machine.cpu_computed.units
    }

    description = local.virtual_machine.description_computed

    disk {
        aio = local.virtual_machine.disk_computed.aio
        backup = local.virtual_machine.disk_computed.backup
        cache = local.virtual_machine.disk_computed.cache
        datastore_id = local.virtual_machine.disk_computed.datastore_id
        discard = local.virtual_machine.disk_computed.discard
        file_format = local.virtual_machine.disk_computed.file_format
        file_id = local.virtual_machine.disk_computed.file_id
        interface = local.virtual_machine.disk_computed.interface
        iothread = local.virtual_machine.disk_computed.iothread
        replicate = local.virtual_machine.disk_computed.replicate
        serial = local.virtual_machine.disk_computed.serial
        size = local.virtual_machine.disk_computed.size
        ssd = local.virtual_machine.disk_computed.ssd
    }

#     efi_disk {
#         datastore_id = local.efi_disk.datastore_id
#         file_format = local.efi_disk.file_format
#         type = local.efi_disk.type
#         pre_enrolled_keys = local.efi_disk.pre_enrolled_keys
#     }

    initialization {
        user_data_file_id = module.cloud_config.cloud_id
        network_data_file_id = module.cloud_config.network_id
    }
                    
    machine = local.virtual_machine.machine_computed

    memory {
        dedicated = local.virtual_machine.memory_computed.dedicated
        floating = local.virtual_machine.memory_computed.floating
        shared = local.virtual_machine.memory_computed.shared
    }

#     network_device {
#         bridge = local.network_device.bridge
#         disconnected = local.network_device.disconnected
#         enabled = local.network_device.enabled
#         firewall = local.network_device.firewall
#         mac_address = local.network_device.mac_address
#         model = local.network_device.model
#     }

#     name = local.name

#     node_name = local.node_name

#     on_boot = local.on_boot

#     operating_system {
#         type = local.operating_system.type
#     }

#     started = local.started

#     startup {
#         order = local.startup.order
#         up_delay = local.startup.up_delay
#         down_delay = local.startup.down_delay
#     }

#     tags = local.tag

#     stop_on_destroy = local.stop_on_destroy

#     vga {
#         memory = local.vga.memory
#         type = local.vga.type
#         clipboard = local.vga.clipboard
#     }

#     vm_id = local.vm_id

    network_device {
        bridge = "vmbr0"
    }

    vga {
        type = "qxl"
        memory = 16
    }

    vm_id = 1102
    name = "docker"
    node_name = "pve"
    
}