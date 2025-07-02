module "cloud_config" {
    source = "../cloud_config"

    config = var.config
    name = "test"
    datastore_id = "config"
    node_name = "pve"
    overwrite = true
    auth = {
        username = "nodadyoushutup"
        github = "nodadyoushutup"
        password = "password"
    }
    ipv4 = {
        address = "192.168.1.185"
    }
}

module "image" {
    source = "../image"

    config = var.config
    name = "test"
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
        enabled = local.agent_computed.enabled
        # timeout = local.agent_computed.timeout
        timeout = "5m"
        trim = local.agent_computed.trim
        type = local.agent_computed.type
    }

    audio_device {
        device = local.audio_device_computed.device
        driver = local.audio_device_computed.driver
        enabled = local.audio_device_computed.enabled
    }

    # bios = local.bios_computed
    bios = "seabios"

    boot_order = local.boot_order_computed

    cpu {
        affinity = local.cpu_computed.affinity
        cores = local.cpu_computed.cores
        flags = local.cpu_computed.flags
        hotplugged = local.cpu_computed.hotplugged
        limit = local.cpu_computed.limit
        numa = local.cpu_computed.numa
        sockets = local.cpu_computed.sockets
        type = local.cpu_computed.type
        units = local.cpu_computed.units
    }

    description = local.description_computed

    disk {
        aio = local.disk_computed.aio
        backup = local.disk_computed.backup
        cache = local.disk_computed.cache
        datastore_id = local.disk_computed.datastore_id
        discard = local.disk_computed.discard
        file_format = local.disk_computed.file_format
        file_id = local.disk_computed.file_id
        interface = local.disk_computed.interface
        iothread = local.disk_computed.iothread
        replicate = local.disk_computed.replicate
        serial = local.disk_computed.serial
        size = local.disk_computed.size
        ssd = local.disk_computed.ssd
    }

#     efi_disk { #TODO
#         datastore_id = local.efi_disk.datastore_id
#         file_format = local.efi_disk.file_format
#         type = local.efi_disk.type
#         pre_enrolled_keys = local.efi_disk.pre_enrolled_keys
#     }

    initialization {
        user_data_file_id = module.cloud_config.cloud_id
        network_data_file_id = module.cloud_config.network_id
    }
                    
    machine = local.machine_computed

    memory {
        dedicated = local.memory_computed.dedicated
        floating = local.memory_computed.floating
        shared = local.memory_computed.shared
    }

    network_device {
        bridge = local.network_device_computed.bridge
        disconnected = local.network_device_computed.disconnected
        enabled = local.network_device_computed.enabled
        firewall = local.network_device_computed.firewall
        mac_address = local.network_device_computed.mac_address
        model = local.network_device_computed.model
    }

#     name = local.name

    node_name = local.node_name_computed

    on_boot = local.on_boot_computed

    operating_system { #TODO
        type = local.operating_system_computed.type
    }

    started = local.started_computed

    startup {
        order = local.startup_computed.order
        up_delay = local.startup_computed.up_delay
        down_delay = local.startup_computed.down_delay
    }

    tags = local.tags_computed

    stop_on_destroy = local.stop_on_destroy_computed

    vga {
        memory = local.vga_computed.memory
        type = local.vga_computed.type
        clipboard = local.vga_computed.clipboard
    }

    vm_id = local.vm_id_computed

    name = "test"
    
}