resource "proxmox_virtual_environment_download_file" "image" {
    content_type = "iso"
    datastore_id = var.image.datastore_id
    node_name = var.image.node_name
    overwrite = true
    overwrite_unmanaged = true
    file_name = "${var.name}-${var.image.file_name}"
    url = var.image.url
}

locals {
    cloud_config ={
        cloud = templatefile(
            "${path.module}/template/cloud_config.yaml.tpl",
            {
                hostname = var.cloud_config.hostname != null ? var.cloud_config.hostname : var.name
                username = var.cloud_config.auth.username
                ssh_public_key = var.cloud_config.auth.ssh_public_key != [] ? var.cloud_config.auth.ssh_public_key : []
                ssh_import = var.cloud_config.auth.github != null ? "su - ${var.cloud_config.auth.username} -c 'ssh-import-id gh:${var.cloud_config.auth.github}'" : "echo 'No SSH import'"
                runcmd = var.cloud_config.runcmd
            }
        )
        talos = templatefile(
            "${path.module}/template/talos_cloud_config.yaml.tpl",
            {
                hostname = var.cloud_config.hostname != null ? var.cloud_config.hostname : var.name
            }
        )
    }
}

resource "proxmox_virtual_environment_file" "cloud" {
    depends_on = [proxmox_virtual_environment_download_file.image]
    content_type = "snippets"
    datastore_id = var.cloud_config.datastore_id
    node_name = var.cloud_config.node_name

    source_raw {
        data = can(regex("talos", var.image.file_name)) ? local.cloud_config.talos : local.cloud_config.cloud
        file_name = "${var.name}-cloud-config.yaml"
    }
}

resource "proxmox_virtual_environment_vm" "virtual_machine" {
    depends_on = [proxmox_virtual_environment_file.cloud]
    agent {
        enabled = var.agent.enabled
        timeout = var.agent.timeout
        trim = var.agent.trim
        type = var.agent.type
    }

    audio_device {
        device = var.audio_device.device
        driver = var.audio_device.driver
        enabled = var.audio_device.enabled
    }

    bios = var.bios

    boot_order = var.boot_order

    cpu {
        cores = var.cpu.cores
        flags = var.cpu.flags
        hotplugged = var.cpu.hotplugged
        limit = var.cpu.limit
        numa = var.cpu.numa
        sockets = var.cpu.sockets
        type = var.cpu.type
        units = var.cpu.units
        affinity = var.cpu.affinity
    }

    description = var.description != null ? var.description : var.name

    disk {
        aio = var.disk.aio
        backup = var.disk.backup
        cache = var.disk.cache
        datastore_id = var.disk.datastore_id
        discard = var.disk.discard
        file_format = var.disk.file_format
        file_id = proxmox_virtual_environment_download_file.image.id
        interface = var.disk.interface
        iothread = var.disk.iothread
        replicate = var.disk.replicate
        serial = var.disk.serial
        size = var.disk.size
        ssd = var.disk.ssd
    }

    efi_disk {
        datastore_id = var.disk.datastore_id
        file_format = var.efi_disk.file_format
        type = var.efi_disk.type
        pre_enrolled_keys = var.efi_disk.pre_enrolled_keys
    }

    initialization {
        datastore_id = var.disk.datastore_id
        user_data_file_id = proxmox_virtual_environment_file.cloud.id
        
        ip_config {
            ipv4 {
                address = "${var.initialization.ip_config.ipv4.address}/${var.initialization.ip_config.ipv4.cidr}"
                gateway = var.initialization.ip_config.ipv4.gateway
            }
            ipv6 {
                address = var.initialization.ip_config.ipv6.address
                gateway = var.initialization.ip_config.ipv6.gateway
            }
        }
    }

    machine = var.machine

    memory {
        dedicated = var.memory.dedicated
        floating = var.memory.floating
        shared = var.memory.shared
    }

    name = var.name

    node_name = var.node_name
    network_device {
        bridge = var.network_device.bridge
        disconnected = var.network_device.disconnected
        enabled = var.network_device.enabled
        firewall = var.network_device.firewall
        mac_address = var.network_device.mac_address
        model = var.network_device.model
    }

    on_boot = var.on_boot

    operating_system {
        type = var.operating_system.type
    }

    started = var.started

    startup {
        order = var.startup.order
        up_delay = var.startup.up_delay
        down_delay = var.startup.down_delay
    }

    tags = var.tags

    stop_on_destroy = var.stop_on_destroy

    vga {
        memory = var.vga.memory
        type = var.vga.type
        clipboard = var.vga.clipboard
    }

    vm_id = var.vm_id
}