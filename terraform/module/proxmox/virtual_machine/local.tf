locals {
    
    image = {
        datastore_id = try(var.image.datastore_id, null) != null ? var.image.datastore_id : try(var.config.global.proxmox.image.datastore_id, null) != null ? var.config.global.proxmox.image.datastore_id : "local"
        node_name = try(var.image.node_name, null) != null ? var.image.node_name : try(var.config.global.proxmox.image.node_name, null) != null ? var.config.global.proxmox.image.node_name : local.node_name
        overwrite = try(var.image.overwrite, null) != null ? var.image.overwrite : try(var.config.global.proxmox.image.overwrite, null) != null ? var.config.global.proxmox.image.overwrite : true
        overwrite_unmanaged = try(var.image.overwrite_unmanaged, null) != null ? var.image.overwrite_unmanaged : try(var.config.global.proxmox.image.overwrite_unmanaged, null) != null ? var.config.global.proxmox.image.overwrite_unmanaged : true
        file_name = try(var.image.file_name, null) != null ? var.image.file_name : try(var.config.global.proxmox.image.file_name, null) != null ? var.config.global.proxmox.image.file_name : "${local.name}-image-amd64.img"
        url = try(var.image.url, null) != null ? var.image.url : try(var.config.global.proxmox.image.url, null) != null ? var.config.global.proxmox.image.url : "https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
    }

    cloud_config = {
        hostname = try(var.cloud_config.hostname, null) != null ? var.cloud_config.hostname : try(var.config.global.proxmox.cloud_config.hostname, null) != null ? var.config.global.proxmox.cloud_config.hostname : local.name
        datastore_id = try(var.cloud_config.datastore_id, null) != null ? var.cloud_config.datastore_id : try(var.config.global.proxmox.cloud_config.datastore_id, null) != null ? var.config.global.proxmox.cloud_config.datastore_id : "local"
        dhcp = try(var.cloud_config.dhcp, null) != null ? var.cloud_config.dhcp : try(var.config.global.proxmox.cloud_config.dhcp, null) != null ? var.config.global.proxmox.cloud_config.dhcp : false
        file_name = try(var.cloud_config.file_name, null) != null ? var.cloud_config.file_name : try(var.config.global.proxmox.cloud_config.file_name, null) != null ? var.config.global.proxmox.cloud_config.file_name : "${local.name}-cloud-config.yaml"
        node_name = try(var.cloud_config.node_name, null) != null ? var.cloud_config.node_name : try(var.config.global.proxmox.cloud_config.node_name, null) != null ? var.config.global.proxmox.cloud_config.node_name : local.node_name
        runcmd = try(var.cloud_config.runcmd, null) != null ? var.cloud_config.runcmd : try(var.config.global.proxmox.cloud_config.runcmd, null) != null ? var.config.global.proxmox.cloud_config.runcmd : []
        auth = {
            github = try(var.cloud_config.auth.github, null) != null ? var.cloud_config.auth.github : try(var.config.global.proxmox.cloud_config.auth.github, null) != null ? var.config.global.proxmox.cloud_config.auth.github : null
            username = try(var.cloud_config.auth.username, null) != null ? var.cloud_config.auth.username : try(var.config.global.proxmox.cloud_config.auth.username, null) != null ? var.config.global.proxmox.cloud_config.auth.username : "nodadyoushutup"
            ssh_public_key = try(var.cloud_config.auth.ssh_public_key, null) != null ? var.cloud_config.auth.ssh_public_key : try(var.config.global.proxmox.cloud_config.auth.ssh_public_key, null) != null ? var.config.global.proxmox.cloud_config.auth.ssh_public_key : []
        }
    }

    template ={
        cloud = templatefile(
            "${path.module}/template/cloud_config.yaml.tpl",
            {
                hostname = local.cloud_config.hostname
                auth = local.cloud_config.auth
                ssh_import = try(local.cloud_config.auth.github, null) != null ? "su - ${local.cloud_config.auth.username} -c 'ssh-import-id gh:${local.cloud_config.auth.github}'" : "echo 'No SSH import'"
                runcmd = local.cloud_config.runcmd
                # dhcp = local.cloud_config.dhcp
            }
        )
        talos = templatefile(
            "${path.module}/template/talos_cloud_config.yaml.tpl",
            {
                hostname = local.cloud_config.hostname
            }
        )
        test = templatefile(
            "${path.module}/template/test.txt.tpl",
            {}
        )
    }

    agent = {
        enabled = try(var.agent.enabled, null) != null ? var.agent.enabled : try(var.config.global.proxmox.agent.enabled, null) != null ? var.config.global.proxmox.agent.enabled : true
        timeout = try(var.agent.timeout, null) != null ? var.agent.timeout : try(var.config.global.proxmox.agent.timeout, null) != null ? var.config.global.proxmox.agent.timeout : "15m"
        trim = try(var.agent.trim, null) != null ? var.agent.trim : try(var.config.global.proxmox.agent.trim, null) != null ? var.config.global.proxmox.agent.trim : false
        type = try(var.agent.type, null) != null ? var.agent.type : try(var.config.global.proxmox.agent.type, null) != null ? var.config.global.proxmox.agent.type : "virtio"
    }

    audio_device = {
        device = try(var.audio_device.device, null) != null ? var.audio_device.device : try(var.config.global.proxmox.audio_device.device, null) != null ? var.config.global.proxmox.audio_device.device : "intel-hda"
        driver = try(var.audio_device.driver, null) != null ? var.audio_device.driver : try(var.config.global.proxmox.audio_device.driver, null) != null ? var.config.global.proxmox.audio_device.driver : "spice"
        enabled = try(var.audio_device.enabled, null) != null ? var.audio_device.enabled : try(var.config.global.proxmox.audio_device.enabled, null) != null ? var.config.global.proxmox.audio_device.enabled : true
    }

    bios = try(var.bios, null) != null ? var.bios : try(var.config.global.proxmox.bios, null) != null ? var.config.global.proxmox.bios : "ovmf"
    
    boot_order = try(var.boot_order, null) != null ? var.boot_order : try(var.config.global.proxmox.boot_order, null) != null ? var.config.global.proxmox.boot_order : ["scsi0"]

    cpu = {
        affinity = try(var.cpu.affinity, null) != null ? var.cpu.affinity : try(var.config.global.proxmox.cpu.affinity, null) != null ? var.config.global.proxmox.cpu.affinity : null
        cores = try(var.cpu.cores, null) != null ? var.cpu.cores : try(var.config.global.proxmox.cpu.cores, null) != null ? var.config.global.proxmox.cpu.cores : 2
        flags = try(var.cpu.flags, null) != null ? var.cpu.flags : try(var.config.global.proxmox.cpu.flags, null) != null ? var.config.global.proxmox.cpu.flags : ["+aes"]
        hotplugged = try(var.cpu.hotplugged, null) != null ? var.cpu.hotplugged : try(var.config.global.proxmox.cpu.hotplugged, null) != null ? var.config.global.proxmox.cpu.hotplugged : 0
        limit = try(var.cpu.limit, null) != null ? var.cpu.limit : try(var.config.global.proxmox.cpu.limit, null) != null ? var.config.global.proxmox.cpu.limit : 0
        numa = try(var.cpu.numa, null) != null ? var.cpu.numa : try(var.config.global.proxmox.cpu.numa, null) != null ? var.config.global.proxmox.cpu.numa : false
        sockets = try(var.cpu.sockets, null) != null ? var.cpu.sockets : try(var.config.global.proxmox.cpu.sockets, null) != null ? var.config.global.proxmox.cpu.sockets : 1
        type = try(var.cpu.type, null) != null ? var.cpu.type : try(var.config.global.proxmox.cpu.type, null) != null ? var.config.global.proxmox.cpu.type : "x86-64-v2-AES"
        units = try(var.cpu.units, null) != null ? var.cpu.units : try(var.config.global.proxmox.cpu.units, null) != null ? var.config.global.proxmox.cpu.units : 1024
    }

    description = try(var.description, null) != null ? var.description : try(var.config.global.proxmox.description, null) != null ? var.config.global.proxmox.description : local.name

    disk = {
        aio = try(var.disk.aio, null) != null ? var.disk.aio : try(var.config.global.proxmox.disk.aio, null) != null ? var.config.global.proxmox.disk.aio : "io_uring"
        backup = try(var.disk.backup, null) != null ? var.disk.backup : try(var.config.global.proxmox.disk.backup, null) != null ? var.config.global.proxmox.disk.backup : true
        cache = try(var.disk.cache, null) != null ? var.disk.cache : try(var.config.global.proxmox.disk.cache, null) != null ? var.config.global.proxmox.disk.cache : "none"
        datastore_id = try(var.disk.datastore_id, null) != null ? var.disk.datastore_id : try(var.config.global.proxmox.disk.datastore_id, null) != null ? var.config.global.proxmox.disk.datastore_id : "virtualization"
        discard = try(var.disk.discard, null) != null ? var.disk.discard : try(var.config.global.proxmox.disk.discard, null) != null ? var.config.global.proxmox.disk.discard : "on"
        file_format = try(var.disk.file_format, null) != null ? var.disk.file_format : try(var.config.global.proxmox.disk.file_format, null) != null ? var.config.global.proxmox.disk.file_format : "raw"
        file_id = try(var.disk.file_id, null) != null ? var.disk.file_id : try(var.config.global.proxmox.disk.file_id, null) != null ? var.config.global.proxmox.disk.file_id : proxmox_virtual_environment_download_file.image.id
        interface = try(var.disk.interface, null) != null ? var.disk.interface : try(var.config.global.proxmox.disk.interface, null) != null ? var.config.global.proxmox.disk.interface : "scsi0"
        iothread = try(var.disk.iothread, null) != null ? var.disk.iothread : try(var.config.global.proxmox.disk.iothread, null) != null ? var.config.global.proxmox.disk.iothread : false
        replicate = try(var.disk.replicate, null) != null ? var.disk.replicate : try(var.config.global.proxmox.disk.replicate, null) != null ? var.config.global.proxmox.disk.replicate : true
        serial = try(var.disk.serial, null) != null ? var.disk.serial : try(var.config.global.proxmox.disk.serial, null) != null ? var.config.global.proxmox.disk.serial : null
        size = try(var.disk.size, null) != null ? var.disk.size : try(var.config.global.proxmox.disk.size, null) != null ? var.config.global.proxmox.disk.size : 20
        ssd = try(var.disk.ssd, null) != null ? var.disk.ssd : try(var.config.global.proxmox.disk.ssd, null) != null ? var.config.global.proxmox.disk.ssd : true
    }

    efi_disk = {
        datastore_id = try(var.efi_disk.datastore_id, null) != null ? var.efi_disk.datastore_id : try(var.config.global.proxmox.efi_disk.datastore_id, null) != null ? var.config.global.proxmox.efi_disk.datastore_id : "virtualization"
        file_format = try(var.efi_disk.file_format, null) != null ? var.efi_disk.file_format : try(var.config.global.proxmox.efi_disk.file_format, null) != null ? var.config.global.proxmox.efi_disk.file_format : "raw"
        type = try(var.efi_disk.type, null) != null ? var.efi_disk.type : try(var.config.global.proxmox.efi_disk.type, null) != null ? var.config.global.proxmox.efi_disk.type : "4m"
        pre_enrolled_keys = try(var.efi_disk.pre_enrolled_keys, null) != null ? var.efi_disk.pre_enrolled_keys : try(var.config.global.proxmox.efi_disk.pre_enrolled_keys, null) != null ? var.config.global.proxmox.efi_disk.pre_enrolled_keys : false
    }

    machine = try(var.machine, null) != null ? var.machine : try(var.config.global.proxmox.machine, null) != null ? var.config.global.proxmox.machine : "q35"

    memory = {
        dedicated = try(var.memory.dedicated, null) != null ? var.memory.dedicated : try(var.config.global.proxmox.memory.dedicated, null) != null ? var.config.global.proxmox.memory.dedicated : 2048
        floating = try(var.memory.floating, null) != null ? var.memory.floating : try(var.config.global.proxmox.memory.floating, null) != null ? var.config.global.proxmox.memory.floating : 0
        shared = try(var.memory.shared, null) != null ? var.memory.shared : try(var.config.global.proxmox.memory.shared, null) != null ? var.config.global.proxmox.memory.shared : 0
    }

    name = try(var.name, null) != null ? var.name : data.external.random_string.result.value
    
    node_name = try(var.node_name, null) != null ? var.node_name : try(var.config.global.proxmox.node_name, null) != null ? var.config.global.proxmox.node_name : var.config.terraform.proxmox.ssh.node.name


    network_device = {
        bridge = try(var.network_device.bridge, null) != null ? var.network_device.bridge : try(var.config.global.proxmox.network_device.bridge, null) != null ? var.config.global.proxmox.network_device.bridge : "vmbr0"
        disconnected = try(var.network_device.disconnected, null) != null ? var.network_device.disconnected : try(var.config.global.proxmox.network_device.disconnected, null) != null ? var.config.global.proxmox.network_device.disconnected : false
        enabled = try(var.network_device.enabled, null) != null ? var.network_device.enabled : try(var.config.global.proxmox.network_device.enabled, null) != null ? var.config.global.proxmox.network_device.enabled : true
        firewall = try(var.network_device.firewall, null) != null ? var.network_device.firewall : try(var.config.global.proxmox.network_device.firewall, null) != null ? var.config.global.proxmox.network_device.firewall : false
        mac_address = try(var.network_device.mac_address, null) != null ? var.network_device.mac_address : try(var.config.global.proxmox.network_device.mac_address, null) != null ? var.config.global.proxmox.network_device.mac_address : null
        model = try(var.network_device.model, null) != null ? var.network_device.model : try(var.config.global.proxmox.network_device.model, null) != null ? var.config.global.proxmox.network_device.model : "virtio"
    }

    on_boot = try(var.on_boot, null) != null ? var.on_boot : try(var.config.global.proxmox.on_boot, null) != null ? var.config.global.proxmox.on_boot : true

    operating_system = {
        type = try(var.operating_system.type, null) != null ? var.operating_system.type : try(var.config.global.proxmox.operating_system.type, null) != null ? var.config.global.proxmox.operating_system.type : "l26"
    }

    started = try(var.started, null) != null ? var.started : try(var.config.global.proxmox.started, null) != null ? var.config.global.proxmox.started : true

    startup = {
        order = try(var.startup.order, null) != null ? var.startup.order : try(var.config.global.proxmox.startup.order, null) != null ? var.config.global.proxmox.startup.order : 1
        up_delay = try(var.startup.up_delay, null) != null ? var.startup.up_delay : try(var.config.global.proxmox.startup.up_delay, null) != null ? var.config.global.proxmox.startup.up_delay : 0
        down_delay = try(var.startup.down_delay, null) != null ? var.startup.down_delay : try(var.config.global.proxmox.startup.down_delay, null) != null ? var.config.global.proxmox.startup.down_delay : 0
    }

    tag = try(var.tag, null) != null ? var.tag : try(var.config.global.proxmox.tag, null) != null ? var.config.global.proxmox.tag : ["gitops"]

    stop_on_destroy = try(var.stop_on_destroy, null) != null ? var.stop_on_destroy : try(var.config.global.proxmox.stop_on_destroy, null) != null ? var.config.global.proxmox.stop_on_destroy : true

    vga = {
        memory = try(var.vga.memory, null) != null ? var.vga.memory : try(var.config.global.proxmox.vga.memory, null) != null ? var.config.global.proxmox.vga.memory : 16
        type = try(var.vga.type, null) != null ? var.vga.type : try(var.config.global.proxmox.vga.type, null) != null ? var.config.global.proxmox.vga.type : "qxl"
        clipboard = try(var.vga.clipboard, null) != null ? var.vga.clipboard : try(var.config.global.proxmox.vga.clipboard, null) != null ? var.config.global.proxmox.vga.clipboard : "vnc"
    }

    vm_id = try(var.vm_id, null) != null ? var.vm_id : try(var.config.global.proxmox.vm_id, null) != null ? var.config.global.proxmox.vm_id : null

    initialization = {
        datastore_id = try(var.initialization.datastore_id, null) != null ? var.initialization.datastore_id : try(var.config.global.proxmox.initialization.datastore_id, null) != null ? var.config.global.proxmox.initialization.datastore_id : "virtualization"
        user_data_file_id = try(var.initialization.user_data_file_id, null) != null ? var.initialization.user_data_file_id : try(var.config.global.proxmox.initialization.user_data_file_id, null) != null ? var.config.global.proxmox.initialization.user_data_file_id : proxmox_virtual_environment_file.cloud_config.id
        ip_config = {
            ipv4 = {
                address = try(var.initialization.ip_config.ipv4.address, null) != null ? var.initialization.ip_config.ipv4.address : try(var.config.global.proxmox.initialization.ip_config.ipv4.address, null) != null ? var.config.global.proxmox.initialization.ip_config.ipv4.address : "dhcp"
                cidr = try(var.initialization.ip_config.ipv4.cidr, null) != null ? var.initialization.ip_config.ipv4.cidr : try(var.config.global.proxmox.initialization.ip_config.ipv4.cidr, null) != null ? var.config.global.proxmox.initialization.ip_config.ipv4.cidr : 24
                gateway = try(var.initialization.ip_config.ipv4.gateway, null) != null ? var.initialization.ip_config.ipv4.gateway : try(var.config.global.proxmox.initialization.ip_config.ipv4.gateway, null) != null ? var.config.global.proxmox.initialization.ip_config.ipv4.gateway : null
            }
            ipv6 = {
                address = try(var.initialization.ip_config.ipv6.address, null) != null ? var.initialization.ip_config.ipv6.address : try(var.config.global.proxmox.initialization.ip_config.ipv6.address, null) != null ? var.config.global.proxmox.initialization.ip_config.ipv6.address : "dhcp"
                gateway = try(var.initialization.ip_config.ipv6.gateway, null) != null ? var.initialization.ip_config.ipv6.gateway : try(var.config.global.proxmox.initialization.ip_config.ipv6.gateway, null) != null ? var.config.global.proxmox.initialization.ip_config.ipv6.gateway : null
            }
        }
    }
}