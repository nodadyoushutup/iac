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




    initialization {
        user_data_file_id = module.cloud_config.cloud_id
        network_data_file_id = module.cloud_config.network_id
    }

    # efi_disk {
    #     datastore_id = "virtualization"
    #     file_format = "raw"
    #     pre_enrolled_keys = false
    # }

    memory {
        dedicated = 8192
    }

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